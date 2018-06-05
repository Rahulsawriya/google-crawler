require 'mechanize'
class Google
  def initialize
    @keyword = ARGV[0]
    @agent = Mechanize.new
  end

  attr_reader :keyword, :agent

  def crawl
    start = 0
    (0..100).each do |n|
      begin
        page = agent.get("https://www.google.co.in/search?q=#{keyword}&start=#{start}&sa=N")
      rescue Mechanize::ResponseCodeError => e
        puts e
        #sleep(0.5)
        next
      end
      
      if page.code == "200"
        page.css('style').remove
        page.css('script').remove
        status = page.css("div[@id='resultStats']").text.strip
        if status =~ /results/i
          page.css("div[@id='ires']/ol/div[@class='g']").each do |section|
            url = section.css('h3/a/@href').to_s.split("?q=")[1].to_s.split("&sa=U&ved")[0].to_s
            source = url.split(/\//)[2].to_s
            puts url
            puts "=" * 50
          end
        else
          break
        end
        start += 10
      end
    end
  end
end
obj = Google.new
obj.crawl
