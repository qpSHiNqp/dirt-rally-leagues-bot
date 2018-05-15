require 'open-uri'
require 'nokogiri'

module RegularEvents
  class BaseUpdateJob < ApplicationJob
    def url
      "https://dirtgame.com/uk/events"
    end

    def selector
      nil
    end

    def detail_url(event_id)
    end

    def perform
      charset = nil
      html = open(url) {|f| charset = f.charset and f.read}
      doc = Nokogiri::HTML.parse(html, nil, charset)
      node = doc.css(selector)

      event_id = node.attribute('data-ng-event-id').text.to_i
      event = Event.create_or_find_by(event_id: event_id) do |e|
        e.type = 'daily1'
      end
      event.update(
        open_at: Time.parse(
          "#{node.search('meta[itemprop="startDate"]').attribute("content").text} +0000"
        ).in_time_zone,
        close_at: Time.parse(
          "#{node.search('meta[itemprop="endDate"]').attribute("content").text} +0000"
        ).in_time_zone,
        stages: 0 # TODO
      )

      # TODO stage info
      #json = open detail_url(event_id) {|f| f.read}
      #data = JSON.parse(json)
      #e.update(title: data["EventName"],
      #        )
    end
  end
end
