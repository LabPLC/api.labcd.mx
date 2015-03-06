def response_endpoint_keys_in(args)
  body = args.fetch(:body)
  parent = args.fetch(:parent, nil)
  children = args.fetch(:children)

  if parent.nil?
    first_level_end_point_keys(body, children)
  else
    second_level_end_point_keys(body, parent, children)
  end
end

def first_level_end_point_keys(body, children)
  children.map { |child| body.has_key?(child) }.reduce {|r,e| r && e}
end


def second_level_end_point_keys(body, parent, children)
  info = body[parent].is_a?(Array) ? body[parent].first : body[parent]
  return false if info.nil?

  children.map { |child| info.has_key?(child) }.reduce {|r,e| r && e}
end
