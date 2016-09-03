RSpec.describe 'Posts', type: :request do
  describe 'index' do
    it 'returns posts in json format' do
      # Setup
      image = File.new(Rails.root + 'spec/fixtures/image.jpg')
      category = Category.create!(name: 'Testing', slug: 'Testing Yada', image: image)
      # Create post through the category relationship (has_many posts)
      post = category.posts.create!(
        title: 'Post for Test',
        summary: 'Post summary yada',
        content: ' yadaaaaaaaa',
        published: true,
        image: image
      )
      # Testing
      # make a get request to url/posts.json (shows the post as json).
      get '/posts.json'
      expect(response).to be_success
      # This gives access to the body of the response: Get all the json (this is a string but we want an object).
      # Using JSON.parse, we convert the string into an object.
      json = JSON.parse(response.body)
      expect(json).to eq(
      #expect json to be an array with one hash (we've created a single post)
      # that has all the attributes we set in index.json.builder
        [
          {
            'id' => post.id,
            'title' => post.title,
            'summary' => post.summary,
            'url' => post_url(post),
            'category' => post.category.name,
            # example.com is the default url
            'image_url' => "http://www.example.com#{post.image.url(:medium)}"
          }
        ]
      )
    end
  end
end
