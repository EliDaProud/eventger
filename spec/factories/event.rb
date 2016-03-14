FactoryGirl.define do
  factory :event do
    title 'Event-licious'
    description 'Hobits gathering with trolls singing celtic songs'
    start_time 1.day.from_now
    end_time 4.days.from_now
    location 'The second dungeon on left'
    icon 'some icon'
  end
end
