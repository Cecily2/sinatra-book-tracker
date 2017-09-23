# Sinatra Book Tracker

Sinatra Book Tracker is a Sinatra CRUD app to keep track of the books that users have read or want to read.

In addition to the gems listed in the gemfile, the website uses the Google Books API to get book information, the Cabin and Lora fonts from Google fonts, Masonry and imagesLoaded for creating a responsive grid, and Font Awesome for icons.

## Installation

Clone this repository to your computer. In the config directory, create a file called api.rb and set `ENV['API_KEY']` to a string containing your [Google Books api key](https://developers.google.com/books/docs/v1/getting_started).

From the project directory, run the terminal command `bundle install`, then `rake db:migrate`, and finally `shotgun`. View the website at localhost:9393 in your browser.

## Usage

Follow the instructions to create a new user account, sign in, and add books to your library. Once logged in, you can view your books through the home page. View other users' books through the Users link in the navbar.

From an individual book page for one of your books, you can delete or edit it. Once you've read a book, edit it to mark it as read and leave a rating and comment.

If the website returns the wrong book, delete it and try again - a specific ISBN may work better than a title. Entering a title followed by an author name may also improve accuracy.