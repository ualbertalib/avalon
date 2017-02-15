# Avalon version five writes a lot of deprecation warnings to
# stderr (which goes to the apache error log). These warnings
# are fixed in Avalon version six. 
if Avalon::VERSION.to_i < 6
  if [:production, :staging, :test].include?(Rails.env.to_sym)
    Deprecation.default_deprecation_behavior = :silence
  end
end
