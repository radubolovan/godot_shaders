tool
extends Sprite

func _ready():
	calculate_aspect_ratio()

func calculate_aspect_ratio():
	material.set_shader_param("aspect_ratio", scale.y / scale.x);

	var the_color = Vector3(0.0, 1.0, 0.0)
	material.set_shader_param("the_color", the_color);
