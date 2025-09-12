require "capybara/rspec"

Capybara.register_driver :headless_chrome_ci do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.args << "--headless=new"
  options.args << "--no-sandbox"
  options.args << "--disable-dev-shm-usage"
  options.args << "--disable-gpu"
  options.args << "--window-size=1400,1400"

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.javascript_driver = :headless_chrome_ci
