class ScratchController < ApplicationController
  

helper :all
require 'rubygems'
#require 'Nokogiri'
require 'open-uri'

helper_method :sort_column, :sort_direction

def home  
@percs={'80%'=>80, '60%'=>60, '40%'=>40, '20%'=>20, '0%'=>0}

s=params[:perc]
@per= params[:perc]==nil ? 0 : s.to_s.to_i
@tix = Ticket.order(sort_column + ' ' + sort_direction)
#@tix=Lotto.where("sold > 80")
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

	@gamenum << l[0]
	@name << l[1]

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
end 
end

private
  def sort_column
    Ticket.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

end
