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
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--window-size=1929,2160')
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
sleep 2
driver.get "https://t.livepocket.jp/e/vs30min"
puts "成功"
sleep 500

# driver.quit
