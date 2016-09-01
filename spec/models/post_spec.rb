require 'rails_helper'

RSpec.describe Post do
  describe '#rendered_content' do
    it 'returns markdown content as html' do
      # Create a new post and give it md content
      post = Post.new(content: '# Yada yada yada')
      html = post.rendered_content.chomp
      expect(html).to eq('<h1 id="yada-yada-yada">Yada yada yada</h1>')
    end
  end

  describe '#to_param' do
    it 'returns id and title to use in URL' do
      # Setup
      post = Post.new(id: 5, title: 'Yada Yada')
      # Actual Testing
      expect(post.to_param).to eq('5-yada-yada')
    end
  end
end
