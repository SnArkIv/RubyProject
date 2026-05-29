module ApplicationHelper
  include Pagy::Frontend

  def header_landing_style?
    (controller_name == "pages" && action_name == "about") ||
      (controller_name == "sessions" && action_name.in?(%w[new create])) ||
      (controller_name == "registrations" && action_name.in?(%w[new create]))
  end

  def active_storage_image_tag(attachment, resize_to_limit:, alt:, **html_options)
    return unless attachment.present?

    source = if attachment.blob&.variable?
      attachment.variant(resize_to_limit: resize_to_limit)
    else
      attachment
    end
    image_tag source, alt: alt, **html_options
  end
end
