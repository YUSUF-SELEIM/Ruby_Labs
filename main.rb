require 'json'

FILE = "books.json"

def load_books(filename)
  return [] unless File.exist?(filename)
  JSON.parse(File.read(filename))
end

def save_books(filename, books)
  File.write(filename, JSON.pretty_generate(books))
end

def list_books(books)
  if books.empty?
    puts "no books in inventory"
    return
  end

  sorted = books.sort_by { |b| b["isbn"] }

  puts "\n inventory (#{sorted.length} book(s)):"
  sorted.each_with_index do |book, index|
    puts "#{index + 1}.Title: #{book["title"]}"
    puts "author:#{book["author"]}"
    puts "ISBN:  #{book["isbn"]}"
    puts "count: #{book["count"]}"
  end
end

def add_book(books, title, author, isbn)
  if title.empty? || author.empty? || isbn.empty?
    puts "error: all fields (title, author, ISBN) are needed"
    return books
  end

  existing = books.find { |b| b["isbn"] == isbn }

  if existing
    existing["count"] += 1
    existing["title"]  = title
    existing["author"] = author
    puts "book already exists updated and count increased to #{existing["count"]}"
  else
    books << {
      "title"  => title,
      "author" => author,
      "isbn"   => isbn,
      "count"  => 1
    }
    puts "'#{title}' is added successfully"
  end

  books
end

def remove_book(books, isbn)
  if isbn.empty?
    puts "error: ISBN cannot be empty"
    return books
  end

  original_size = books.length
  books.reject! { |b| b["isbn"] == isbn }

  if books.length == original_size
    puts "no book found with ISBN: #{isbn}"
  else
    puts "book removed successfully"
  end

  books
end

def search_books(books, query, field)
  if query.empty?
    puts "error: Search query cannot be empty"
    return
  end

  results = books.select { |b| b[field].downcase.include?(query.downcase) }

  if results.empty?
    puts "no books found matching '#{query}'"
  else
    puts "\n search results for '#{query}':"
    list_books(results)
  end
end

def menu
  puts "menu"
  puts "1. list all books"
  puts "2. add a book"
  puts "3. remove a book"
  puts "4. search by title"
  puts "5. search by author"
  puts "6. search by ISBN"
  puts "7. exit"
  print "Enter your choice (1-7): "
  (gets || "").chomp
end

puts "the start of the program"
books = load_books(FILE)

loop do
  choice = menu

  case choice
  when "1"
    list_books(books)

  when "2"
    print "title:  "
    title = gets.chomp
    print "author: "
    author = gets.chomp
    print "ISBN:   "
    isbn = gets.chomp
    books = add_book(books, title, author, isbn)
    save_books(FILE, books)

  when "3"
    print "enter ISBN to remove: "
    isbn = gets.chomp
    books = remove_book(books, isbn)
    save_books(FILE, books)

  when "4"
    print "search by title: "
    query = gets.chomp
    search_books(books, query, "title")

  when "5"
    print "search by author: "
    query = gets.chomp
    search_books(books, query, "author")

  when "6"
    print "search by ISBN: "
    query = gets.chomp
    search_books(books, query, "isbn")

  when "7"
    puts "exit"
    break

  else
    puts "enter a number between 1 and 7"
  end
end