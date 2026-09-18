extends Node3D

@export var target_size: float = 30.0
@export var generate_collision: bool = true

@onready var island_mesh: MeshInstance3D = $IslandMesh


func _ready() -> void:
	if island_mesh.mesh == null:
		push_error("Island mesh bulunamadı.")
		return

	_fit_island()

	if generate_collision:
		_create_collision()


func _fit_island() -> void:
	var aabb := island_mesh.mesh.get_aabb()

	var horizontal_size := max(aabb.size.x, aabb.size.z)

	if horizontal_size <= 0.0:
		return

	var scale_factor := target_size / horizontal_size

	island_mesh.position = Vector3(
		-(aabb.position.x + aabb.size.x * 0.5),
		-aabb.position.y,
		-(aabb.position.z + aabb.size.z * 0.5)
	)

	scale = Vector3.ONE * scale_factor

	print("Island bounds: ", aabb.size)
	print("Island scale: ", scale_factor)


func _create_collision() -> void:
	if island_mesh.get_node_or_null("StaticBody3D") != null:
		return

	island_mesh.create_trimesh_collision()
	print("Island collision hazır.")
