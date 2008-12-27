require 'time'
start_time = Time.local(0,0,13,31,12,2008,0,0,false,'Asia/Tokyo')#Time.utc(2008, 12, 31, 12, 0, 'Asia/Tokyo')#08/12/31 12:00

0.upto(35) do |i|
  content = "未定"
  time = start_time + i.hours
  Plan.create(:content=> content, :start=> time)
end
