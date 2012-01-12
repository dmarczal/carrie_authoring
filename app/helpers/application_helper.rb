module ApplicationHelper
  def markdown(text)
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end

  def menu_link_to(*args, &block)
    link_path = args[1]
    path = request.path.match(/(\/{1}\w*)\/?/)[1] # extract the father controller

    class_property = "active" if path == link_path
    content_tag :li, :class => class_property do
      link_to *args, &block
    end
  end

  def twitterized_type(type)
    case type
    when :alert
      "warning"
    when :error
      "error"
    when :notice
      "info"
    when :success
      "success"
    else
      type.to_s
    end
  end
end
