@tool
extends SceneTree

var plugins = {}

func make_request(url: String,
				custom_headers: PackedStringArray = PackedStringArray(),
				method: HTTPClient.Method = 0,
				request_data: String = "") -> HTTPRequest:
	var http := HTTPRequest.new()
	http.request_completed.connect(http.queue_free.unbind(4))
	get_root().add_child(http)
	http.request(url, custom_headers, method, request_data)
	return http


func _init() -> void:
	print ("starting godot-package")
	call_deferred('install_requirements')


func _ready():
	print ("_ready")


func dependency(repo, args={}):
	var plugin = {}
	plugin.repo = repo
	plugin.repository_name = repo.split('/')[1]
	plugin.owner = repo.split('/')[0]
	plugin.tag = args['tag']
	plugin.name = args['name'] if 'name' in args else null

	if plugin.name:
		print ("installing dependency for %s#%s" % [repo, plugin.name])
		plugin.id = "%s:%s" % [repo, plugin.name]
	else:
		print ("installing dependency for %s" % [repo])
		plugin.id = "%s" % [repo]

	get_release(plugin)


func get_release(plugin):
	var url = "https://api.github.com/repos/%s/%s/releases" % [plugin.owner, plugin.repository_name]
	var http = make_request(url, [], HTTPClient.METHOD_GET)

	var cb = func(result: int, code: int, headers: PackedStringArray, body: PackedByteArray):
		var json = JSON.parse_string(body.get_string_from_utf8())

		var release_id
		for release in json:
			if release['tag_name'] == plugin.tag:
				release_id = release['id']

		if not release_id:
			print ('Could not find release for %s:%s' %[plugin.repo, plugin.tag])
			plugins[plugin.id] = false
		else:
			plugin.release_id = release_id
			get_download_url(plugin)

		http.queue_free()

	plugins[plugin.id] = true
	http.request_completed.connect(cb)


func get_download_url(plugin):
	var url = "https://api.github.com/repos/%s/%s/releases/%s" % [plugin.owner, plugin.repository_name, plugin.release_id]
	var http = make_request(url, [], HTTPClient.METHOD_GET)

	var cb = func(result: int, code: int, headers: PackedStringArray, body: PackedByteArray):
		var json = JSON.parse_string(body.get_string_from_utf8())
		var download_url = json['assets'][0]['browser_download_url']
		if plugin.name:
			for asset in json['assets']:
				if asset['name'] == plugin.name:
					download_url = asset['browser_download_url']

		print ('downloading from %s' % [download_url])
		http.queue_free()
		download_plugin(plugin, download_url)

	http.request_completed.connect(cb)


func download_plugin(plugin, download_url):
	var url = download_url
	var http = make_request(url, [], HTTPClient.METHOD_GET)

	var cb = func(result: int, code: int, headers: PackedStringArray, body: PackedByteArray):
		var file = FileAccess.open("user://%s.zip" % [plugin.repository_name], FileAccess.WRITE)
		file.store_buffer(body)
		file.close()

		var reader = ZIPReader.new()
		var err = reader.open("user://%s.zip" % [plugin.repository_name])

		var dir_access = DirAccess.open('.')

		for filepath in reader.get_files():
			print (filepath)
			dir_access.make_dir_recursive(filepath.get_base_dir())
			var file_access: FileAccess = FileAccess.open(filepath, FileAccess.WRITE)
			var file_contents = reader.read_file(filepath)
			if file_contents:
				file_access.store_buffer(file_contents)

		http.queue_free()

		plugins[plugin.id] = false

	http.request_completed.connect(cb)


func install_requirements():
	_requirements()
	call_deferred("do_quit")


func do_quit():
	if is_busy():
		await create_timer(2).timeout
		call_deferred("do_quit")
	else:
		quit()


func is_busy():
	var result = false

	for plugin in plugins:
		result = result || plugins[plugin]
		
	return result

func _requirements():
	pass
