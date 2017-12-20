#!/usr/bin/env ruby
#encoding: utf-8

gem 'selenium-webdriver' , '=3.0.0'
require 'selenium-webdriver'

url = 'http://www.icourse163.org/university/view/all.htm#/'

browser0 = Selenium::WebDriver.for :phantomjs
browser1 = Selenium::WebDriver.for :phantomjs
browser2 = Selenium::WebDriver.for :phantomjs

STDERR.puts '序号,开课单位,课程名称,课程时长,课程负载,内容类型,课程分类,参加人数,课程链接'
STDOUT.puts '序号,开课单位,课程名称,课程时长,课程负载,内容类型,课程分类,参加人数,课程链接'

browser0.get(url)
sleep 1

cnt = 0

# 大学
university = browser0.find_elements(:class=>'u-usity')
university.each do |i|
    university_url = i['href'].to_s
    university_name = i.find_element(:xpath=>'img')['alt'].to_s
    
    browser1.get(university_url)
    sleep 1

    # 课程
    loop{
        course = browser1.find_element(:class=>'u-ctlist').find_elements(:class=>'g-cell1')

        course.each do |j|
            course_url = "http://www.icourse163.org" + j['data-href'].to_s
            course_name = j.find_element(:class=>'card').find_element(:class=>'f-f0').text
            
            browser2.get(course_url)
            sleep 1

            # 课程信息
            course_text = browser2.find_elements(:class=>'block')
            begin
                person_num = browser2.find_element(:class=>'m-termInfo').find_element(:class=>'j-num').text
                person_num.gsub!(/[^0-9]/i, '')
            rescue
                person_num = ''
            end
            cnt +=1
            attribute = Hash.new
            begin
                course_text.each { |c|
                    k = c.find_elements(:xpath=>'div')
                    attribute[k[0].text] = k[1].text
                }
            rescue
                
            end
            STDERR.puts cnt.to_s + ',' + university_name + ',' + course_name + ',' + attribute['课程时长'].to_s + ',' + attribute['课程负载'].to_s + ',' + attribute['内容类型'].to_s + ',' + attribute['课程分类'].to_s + ',' + person_num + ',' + course_url
            STDOUT.puts cnt.to_s + ',' + university_name + ',' + course_name + ',' + attribute['课程时长'].to_s + ',' + attribute['课程负载'].to_s + ',' + attribute['内容类型'].to_s + ',' + attribute['课程分类'].to_s + ',' + person_num + ',' + course_url
        end

        begin
            next_page = browser1.find_element(:class=>'u-ctlist').find_element(:class=>'znxt')
            break if next_page.attribute("class").include?("js-disabled")
            next_page.click
            sleep 1
        rescue Exception => e
            break
        end
    }
end

browser2.close
browser1.close
browser0.close
