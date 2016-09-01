require 'rails_helper'

RSpec.describe Post do
  describe '#rendered_content' do
    it 'returns markdown content as html' do
      # Create a new post and give it md content
      post = Post.new(content: '# Yada yada yada')
      html = post.rendered_content.chomp
      expect(html).to eq('<h1>Yada yada yada</h1>')
    end
  end
end
