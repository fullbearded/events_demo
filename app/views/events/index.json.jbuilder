json.data do
  json.pagination do
    json.total_pages @events.total_pages
    json.total_entries @events.total_count
    json.page @events.current_page
    json.previous_page @events.prev_page
    json.next_page @events.next_page
  end
  json.events do
    json.array! @events do |event|
      json.operator event.user.name
      json.action event.action_display
      json.resource_name event.resource_name_display
      json.link event.resource_detail[:link]
      json.content event.resource_detail[:content] || ''
      json.title event.resource_detail[:name]
    end
  end
end
