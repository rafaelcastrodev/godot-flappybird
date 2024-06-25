class_name BackgroundParallax;
extends Node2D

signal floor_touched;
@onready var area_2d: Area2D = $Area2D
@onready var bg_sky: ParallaxLayer = $ParallaxBackground/BgSky
@onready var bg_clouds: ParallaxLayer = $ParallaxBackground/BgClouds
@onready var bg_buildings: ParallaxLayer = $ParallaxBackground/BgBuildings
@onready var bg_forest: ParallaxLayer = $ParallaxBackground/BgForest
@onready var bg_floor: ParallaxLayer = $ParallaxBackground/BgFloor


func _ready() -> void:
	area_2d.body_entered.connect(_on_area_body_entered);
#}


func _on_area_body_entered(body: Node2D) -> void:
	floor_touched.emit();
#}
