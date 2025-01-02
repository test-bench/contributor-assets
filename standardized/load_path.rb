require_relative 'gems/gems_init'

lib_parent_dir = __dir__

reference_dir = File.dirname(caller[0] || __FILE__)
if File.directory?(reference_dir)
  full_reference_dir = File.expand_path(reference_dir)
  is_local = full_reference_dir.start_with?(__dir__)
  if is_local && File.directory?(File.join(full_reference_dir, 'lib'))
    lib_parent_dir = full_reference_dir
  end
end

lib_dir = File.expand_path('lib', lib_parent_dir)
if File.directory?(lib_dir)
  if not $LOAD_PATH.include?(lib_dir)
    $LOAD_PATH.unshift(lib_dir)
  end
end

libraries_dir = ENV['LIBRARIES_HOME']
return if libraries_dir.nil?

libraries_dir = File.expand_path(libraries_dir)

Dir.glob("#{libraries_dir}/*/lib") do |library_dir|
  if not $LOAD_PATH.include?(library_dir)
    $LOAD_PATH.unshift(library_dir)
  end
end
