require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
	url = 'https://blockwork.cc/'
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	jobs = Array.new
	job_listings = parsed_page.css('div.listingCard') #50 jobs
	page = 1
	per_page = job_listings.count
	total = parsed_page.css('div.job-count').text.split(' ')[1].gsub(',','').to_i
	last_page = (total.to_f / per_page.to_f ).round #46
	while page <= last_page
			pagination_url = "https://blockwork.cc/listings?page=#{page}"
			puts pagination_url
			puts "Page #{page}"
			puts ''
			pagination_unparsed_page = HTTParty.get(pagination_url)
			pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
			pagination_job_listings = pagination_parsed_page.css('div.listingCard')
			pagination_job_listings.each do |job_listing|
				job = {
					title: job_listing.css('span.job-title').text,
					company: job_listing.css('span.company').text,
					location: job_listing.css('span.location').text,
					url: "https://blockwork.cc/" + job_listing.css('a')[0].attributes["href"].value
				}
				jobs << job
				puts "Added #{job[:title]}"
				puts ''
			end
			page += 1
	end
	byebug
end

#target the div with class listingCard
#parsed_page.css('div.listingCard')
#jobCards = parsed_page.css('div.listingCard')
#jobCards.count //50
#jobCards.first //first job
#first_job = jobCards.first
#the title is wrapped in a span with class job-title
#first_job.css('span.job-title') to get to the job title nokogiri format
#first_job.css('span.job-title').text to get the title
#first_job.css('span.company').text to get the company
#first_job.css('span.location').text to get the location
#first_job.css('a') to see the a tag insode the block
#first_job.css('a')[0] get the first item in the array
#first_job.css('a')[0].attributes  to get the attributes
#first_job.css('a')[0].attributes["href"]
#first_job.css('a')[0].attributes["href"].value to get the url
#pagoination -> https://blockwork.cc/listings?page=2 
#parsed_page.css('div.job-count') gives the nokogiri object of total job count
#parsed_page.css('div.job-count').text gives the text
#parsed_page.css('div.job-count').text.split(' ') this separates the resulting text into strings
#parsed_page.css('div.job-count').text.split(' ')[1] will give the string "2,287"
#parsed_page.css('div.job-count').text.split(' ')[1].gsub(',','') gets rid of the comma
#parsed_page.css('div.job-count').text.split(' ')[1].gsub(',','').to_i to convert string to integer
#while loop for pagination
scraper