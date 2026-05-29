json.reviews @reviews do |review|
  json.id review.id
  json.rating review.rating
  json.comment review.comment
  json.user do
    json.email review.user.email
  end
  json.created_at review.created_at
end
