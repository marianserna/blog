module ApplicationHelper
  def display_title
    page_title = content_for?(:title) ? content_for(:title) : 'Blog'
    "#{page_title} | Marian Serna"
  end

  def title(text)
    content_for(:title) do
      text
    end
  end
end
