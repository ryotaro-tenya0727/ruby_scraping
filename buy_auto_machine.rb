require 'selenium-webdriver'
require 'dotenv'
require 'pry'

TICKET_URL = "https://t.livepocket.jp/e/naniyori0116"

options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
options.add_argument('--window-size=1929,2160')
driver = Selenium::WebDriver.for :chrome, options: options #ドライバ選択
wait = Selenium::WebDriver::Wait.new(timeout: 100)
driver.get "https://t.livepocket.jp/login?acroot=header-new_p_u_nl"

# ログイン処理
Dotenv.load
email = ENV['EMAIL']
pass = ENV['PASS']
driver.find_element(:xpath, '//*[@id="email"]').send_key email
driver.find_element(:xpath, '//*[@id="password"]').send_key pass
driver.find_element(:xpath, '//*[@id="form"]/p[5]/button').click
wait.until { driver.find_element(:id, 'myTicket') }

# ログイン画面への遷移が確認できたら、チケット詳細画面へ
driver.get TICKET_URL

# チケットの枚数を選択して購入ボタンを押す
wait.until { driver.find_element(:id, 'information') }
select_elements = wait.until { driver.find_elements(:css, 'select[id^="ticket-"]') }
min_select_element = select_elements.min_by { |element| element.attribute('id').split("-").last.to_i }
select = Selenium::WebDriver::Support::Select.new(min_select_element)
select.select_by(:index, 1)
button = wait.until { driver.find_element(:id, 'submit').find_element(:class, 'btn-procedure-pc-only').find_element(:class, 'register_input_submit_pink') }
sleep 0.3
button.click

# 同意ボタンにチェック
checkbox_element = wait.until { driver.find_element(:id, 'agreement_check_lp') }
checkbox_element.click

button = wait.until { driver.find_element(:id, 'submit-btn').find_element(:name, 'sbm') }
button.click

alert = wait.until { driver.switch_to.alert }
alert.accept
form = wait.until { driver.find_element(:name, 'creditFepChargePaymentInfoReferenceActionForm') }
code_input = form.find_element(:name, 'securityCode')
code_input.send_keys ENV['CODE']
button = driver.find_element(:id, 'exec-button')
button.click
form = wait.until { driver.find_element(:name, 'fepChargeIntensionConfirmActionForm') }
button = form.find_element(:id, 'exec-button')
button.click

puts driver.title
sleep 500

# driver.quit
