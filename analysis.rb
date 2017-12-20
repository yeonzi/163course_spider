#!/usr/bin/env ruby
#encoding: utf-8

csv = Array.new
title = Array.new

def csv_num_qsort(csv,item)
    return csv if csv.size < 2
    (x = csv.pop) ?  csv_num_qsort(csv.select{|i| i[item].to_i <=x[item].to_i },item) + [x] + csv_num_qsort(csv.select{|i| i[item].to_i > x[item].to_i},item) : []
end

def csv_string_qsort(csv,item)
    return csv if csv.size < 2
    (x = csv.pop) ?  csv_string_qsort(csv.select{|i| i[item] <=x[item] },item) + [x] + csv_string_qsort(csv.select{|i| i[item] > x[item]},item) : []
end

def aray_qsort(a,n)
    return a if a.size < 2
    (x = a.pop) ?  aray_qsort(a.select{|i| i[n].to_i <=x[n].to_i },n) + [x] + aray_qsort(a.select{|i| i[n].to_i > x[n].to_i},n) : []
end

h = 1
buf = nil
open("mooc.csv","r") do |file|
	file.each_line do |s|
		s.chomp! #改行文字\nを取り除きつつbufに値を格納
		buf = s.split(',')
		if h > 0
			h = 0
			title = buf
			next
		end	
		csv << Hash[title.zip(buf.map)]
	end
end

schools = Hash.new 0
classes = Hash.new 0
listener = Hash.new 0
class_num = Hash.new 0
class_num2 = Hash.new 0
class_listen = Hash.new 0

listener_cnt = 0

csv.each { |mooc|
	schools[mooc['开课单位']] +=1
	classes[mooc['课程分类']] +=1
	listener[mooc['开课单位']] += mooc['参加人数'].to_i
	cname = mooc['课程名称'].gsub(/[（(].*?[)）]/,'')
	class_num[cname] += 1
	class_listen[cname] += mooc['参加人数'].to_i
	cname.gsub!(/[\s—-（].*?$/,'')
	class_num2[cname] += 1

	listener_cnt += mooc['参加人数'].to_i
}

##############################################################################


puts "总共包含来自 #{schools.length} 个单位的 #{csv.length} 门课程，总听课人次 #{listener_cnt}"
puts ''
c = schools.to_a
c = aray_qsort(c,1).reverse!
puts '开设课程较多的学校包括'
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 共计开设 #{c[i][1]}门"
}
puts ''

puts '其中最受欢迎的课程为'
csv_sort = csv_num_qsort(csv,'参加人数').reverse!
(0..10).each{ |i|
	puts "#{csv_sort[i]['开课单位']} 开设的 " + csv_sort[i]['课程名称'] + " 课程，共计#{csv_sort[i]['参加人数']}人参加"
}
puts ''

puts "听课人数最多的学校为"
c = listener.to_a
c = aray_qsort(c,1).reverse!
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 单位的 #{schools[c[i][0]]}门课程，共计 #{c[i][1]} 人参与"
}
puts ''

puts "听课人数最少的学校为"
c = listener.to_a
c = aray_qsort(c,1)
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 单位的 #{schools[c[i][0]]}门课程，共计 #{c[i][1]} 人参与"
}
puts ''

puts "总共包含 #{classes.length} 种门类门课程"
puts ''

c = classes.to_a
c = aray_qsort(c,1).reverse!
puts '其中受众最大的类别为'
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]}  #{c[i][1]}门"
}
puts ''

puts "开设最多的课程为"
c = class_num.to_a
c = aray_qsort(c,1).reverse!
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 课程，共计 #{c[i][1]}"
}
puts ''

# puts "开设最多的课程为"
# c = class_num2.to_a
# c = aray_qsort(c,1).reverse!
# (0..10).each{ |i|
# 	next if c[i][0] == ''
# 	puts "#{c[i][0]} 课程，共计 #{c[i][1]}"
# }
# puts ''

puts "听课人数最多的课程为"
c = class_listen.to_a
c = aray_qsort(c,1).reverse!
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 课程，共计 #{c[i][1]}"
}
puts ''

puts "听课人数最少的课程为"
c = class_listen.to_a
c = aray_qsort(c,1)
(0..10).each{ |i|
	next if c[i][0] == ''
	puts "#{c[i][0]} 课程，共计 #{c[i][1]}"
}
puts ''
