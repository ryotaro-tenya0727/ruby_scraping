# require 'open-uri'
# require 'nokogiri'
# require 'launchy'

# url = 'https://www.yahoo.co.jp/'

# html = URI.open(url).read
# Launchy.open(url)

# doc = Nokogiri::HTML.parse(html)

# title = doc.title
# puts title

# -*- coding: utf-8 -*-
require 'selenium-webdriver'
require 'dotenv'
require 'pry'

options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
# options.add_argument('--window-size=1929,2160')
driver = Selenium::WebDriver.for :chrome, options: options #ドライバ選択
driver.get "https://t.livepocket.jp/login?acroot=header-new_p_u_nl"
puts driver.title #タイトルを出力

# meta descriptionを取ってくる場合
# element = driver.find_element(:name, 'description')
# puts element.attribute('content')

Dotenv.load
email = ENV['EMAIL']
pass = ENV['PASS']

driver.find_element(:xpath, '//*[@id="email"]').send_key email
driver.find_element(:xpath, '//*[@id="password"]').send_key pass
driver.find_element(:xpath, '//*[@id="form"]/p[5]/button').click
sleep 3
ticket_url = "https://t.livepocket.jp/e/idolkoushien-0223-"
driver.get ticket_url
select_elements = driver.find_elements(:css, 'select[id^="ticket-"]')
min_select_element = select_elements.min_by { |element| element.attribute('id').split("-").last.to_i }
# Selectクラスを使って要素を選択します
select = Selenium::WebDriver::Support::Select.new(min_select_element)

# インデックスで選択
select.select_by(:index, 1)
# binding.pry
puts driver.title
sleep 500

# driver.quit
