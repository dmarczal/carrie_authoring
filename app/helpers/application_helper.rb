module ApplicationHelper
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(text, *options).to_html.html_safe
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

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
