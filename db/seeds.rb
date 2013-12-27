# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
#require 'Nokogiri'
require 'open-uri'

@gamenum=Array.new
@price=Array.new
@name=Array.new
@sold=Array.new
@numtix=Array.new
@remaining=Array.new
@ratio=Array.new
url = 'http://vtlottery.com/allgames/scratchgames.aspx'
@doc = Nokogiri::HTML(open(url))

@doc.css('div#outst tr').each do |fuck|
	t=fuck.search('td/text()')
	l=fuck.search('td/a[@href]/text()')
 	i=t.length
	s=t[0].to_s
	s.slice!(0)
	@price << s.to_f

	d=l[0]
	r=l.to_s
	r=r.to_i
	@gamenum << r

	d=l[1]
	r=d.to_s
	@name << r

	s=t[i-3].to_s
	s=s.gsub(/\,/,"")
	s=s.gsub(/\$/,"")
	@remaining << s.to_f

	s=t[i-2].to_s
	@sold << s.to_f

	s=t[i-1].to_s
	s=s.gsub(/\,/,"")
	@numtix << s.to_f

	@ratio << @remaining.last/((1-@sold.last/100)*@numtix.last*@price.last)

	Tickets.create(price: @price.last, gid: @gamenum.last, name: @name.last,
		sold: @sold.last, outstanding: @remaining.last, 
		numtix: @numtix.last, ratio: @ratio.last)
	Tickets.delete_all("price < 1")
end
