module EventsHelper
  def time_str_to_number(str)
    tmp = str.split(":")
    tmp[0].to_i*60 + tmp[1].to_f
  end
  def time_number_to_str(num)
    sec = num % 60
    min = (num / 60).floor
    sprintf "%02d:%06.3f", min, sec
  end

  def calc_stage_diff(rec_prev, rec_curr)
    curr = JSON.parse(rec_curr.content)
    return curr if rec_prev.blank?

    prev = JSON.parse(rec_prev.content)

    top = Float::INFINITY
    curr.each do |entry|
      tmp = prev.select{|e| e["Name"] == entry["Name"]}[0] # search matching result
      entry["TimeInSec"] = time_str_to_number(entry["Time"]) - time_str_to_number(tmp["Time"])
      entry["Time"] = time_number_to_str(entry["TimeInSec"])
      top = entry["TimeInSec"] if entry["TimeInSec"] < top
    end
    curr.sort_by {|item| item["TimeInSec"]}
      .each do |entry|
      diff = entry["TimeInSec"] - top
      entry["DiffFirst"] = diff > 0 ? "+#{time_number_to_str(diff)}" : "--"
    end
  end
end
