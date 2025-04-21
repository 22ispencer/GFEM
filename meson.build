project('gfem', 'cpp', default_options : ['cpp_std= c++23'])

gtkmm_dep = dependency('gtkmm-4.0')

subdir('src')

executable('gfem', src_files, include_directories: src_include, install: true, dependencies: [gtkmm_dep])
