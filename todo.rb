# todo.rb
require 'sinatra'
require 'csv'

get '/' do
  erb :todoMain
end

post '/' do
  if params[:add] == "Add Task"
    erb :todoAdd
  elsif params[:clear] == "Clear Task"
    erb :todoRemove
  elsif params[:update] == "Update Task"
    erb :todoUpdate
  else
    "Well Butts"
  end
end

post '/remove' do
  arr_of_arrs = CSV.read("list.csv")
  arr_of_arrs.delete_at(params[:number].to_i - 1)
  CSV.open("list.csv", "wb") do |csv|
    arr_of_arrs.each do |row|
      csv << row
    end
  end
  erb :todoMain
end

post '/add' do
  arr_of_arrs = CSV.read("list.csv")
  CSV.open("list.csv", "ab") do |csv|
    csv << [(arr_of_arrs.count + 1).to_s, params[:taskName]]
  end
  erb :todoMain
end

post '/update/task/:number' do
  arr_of_arrs = CSV.read("list.csv")
  if params[:complete] == nil
    complete = nil
  else
    complete = "on"
  end
  arr_of_arrs[params[:number].to_i - 1] = [params[:number], params[:name], complete]
  CSV.open("list.csv", "wb") do |csv|
    arr_of_arrs.each do |row|
      csv << row
    end
  end
  erb :todoMain
end

post '/update/init' do
  page = "Task Number: #{params[:number]}
<hr>
<br>
<form action='/update/task/#{params[:number]}' method='post'>
<% arr_of_arrs = CSV.read('list.csv') %>
<% arr = arr_of_arrs[#{params[:number]}.to_i - 1] %>
Task Name: <input type='test' name='name' value='<%= arr[1] %>'>
<br>
Completed: <input type='checkbox' name='complete'
<% if arr[2] == nil %>
<% else %>
  checked=on
<% end %>>
<br>
<input type='submit'>
</form>"

erb page

end
