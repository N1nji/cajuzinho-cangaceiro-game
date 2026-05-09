extends Node
class_name PlayerCamera

var player: CharacterBody2D
var remote: RemoteTransform2D

func init(p, r):
	player = p
	remote = r

func follow_camera(cam: Camera2D):
	remote.remote_path = cam.get_path()
