[gd_scene load_steps=22 format=3 uid="uid://c8fm5k1pu6l4i"]

[ext_resource type="Script" path="res://dungeon.gd" id="1_ifql2"]
[ext_resource type="Texture2D" uid="uid://cdejfmb3r8r6b" path="res://environment/cave1.png" id="2_nq54f"]
[ext_resource type="Texture2D" uid="uid://w72furwr3cqb" path="res://environment/cavewalls1.png" id="3_gtmqh"]
[ext_resource type="Texture2D" uid="uid://dtmfkxp1v7kq" path="res://environment/funguscave1.png" id="4_efs67"]
[ext_resource type="Texture2D" uid="uid://domoj1a0tcvuy" path="res://environment/funguscavewalls1.png" id="5_rqtvc"]
[ext_resource type="Script" path="res://debug_UI.gd" id="6_grh6y"]
[ext_resource type="Texture2D" uid="uid://2uvs3oud5cvk" path="res://debug_buttons.png" id="6_jqwbb"]
[ext_resource type="PackedScene" uid="uid://eb8v1h7u5ytm" path="res://Health Functions/hearts_container.tscn" id="6_tho0w"]
[ext_resource type="PackedScene" uid="uid://crcqnnl6ies46" path="res://cassandra_scene.tscn" id="11_ai3vm"]
[ext_resource type="AudioStream" uid="uid://dhiy4c1nn72yc" path="res://Music/background sound.mp3" id="13_7lc74"]
[ext_resource type="PackedScene" uid="uid://cul7b22epo42i" path="res://InventoryTesting/inventory_gui.tscn" id="13_87dgk"]
[ext_resource type="PackedScene" uid="uid://dryac8f57oat6" path="res://Pause Menu/pause_menu.tscn" id="13_cipy3"]
[ext_resource type="Script" path="res://BackgroundSound.gd" id="14_1o1d0"]
[ext_resource type="PackedScene" uid="uid://8mujy3eharaw" path="res://potion_1.tscn" id="14_4maq5"]

[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_yqjvn"]
texture = ExtResource("2_nq54f")
texture_region_size = Vector2i(64, 32)
0:0/0 = 0
0:0/0/terrain_set = 0
0:0/0/terrain = 0
0:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:0/0/physics_layer_0/angular_velocity = 0.0
0:0/0/terrains_peering_bit/right_corner = 0
0:0/0/terrains_peering_bit/bottom_right_side = 0
0:0/0/terrains_peering_bit/bottom_corner = 0
0:0/0/terrains_peering_bit/bottom_left_side = 0
0:0/0/terrains_peering_bit/top_right_side = 0
1:0/0 = 0
1:0/0/terrain_set = 0
1:0/0/terrain = 0
1:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:0/0/physics_layer_0/angular_velocity = 0.0
1:0/0/terrains_peering_bit/bottom_right_side = 0
1:0/0/terrains_peering_bit/bottom_corner = 0
1:0/0/terrains_peering_bit/bottom_left_side = 0
0:1/0 = 0
0:1/0/terrain_set = 0
0:1/0/terrain = 0
0:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:1/0/physics_layer_0/angular_velocity = 0.0
0:1/0/terrains_peering_bit/right_corner = 0
0:1/0/terrains_peering_bit/bottom_right_side = 0
0:1/0/terrains_peering_bit/top_right_side = 0
1:1/0 = 0
1:1/0/terrain_set = 0
1:1/0/terrain = 0
1:1/0/probability = 0.2
1:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:1/0/physics_layer_0/angular_velocity = 0.0
1:1/0/terrains_peering_bit/right_corner = 0
1:1/0/terrains_peering_bit/bottom_right_side = 0
1:1/0/terrains_peering_bit/bottom_corner = 0
1:1/0/terrains_peering_bit/bottom_left_side = 0
1:1/0/terrains_peering_bit/left_corner = 0
1:1/0/terrains_peering_bit/top_left_side = 0
1:1/0/terrains_peering_bit/top_corner = 0
1:1/0/terrains_peering_bit/top_right_side = 0
0:2/0 = 0
0:2/0/terrain_set = 0
0:2/0/terrain = 0
0:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:2/0/physics_layer_0/angular_velocity = 0.0
0:2/0/terrains_peering_bit/right_corner = 0
0:2/0/terrains_peering_bit/bottom_right_side = 0
0:2/0/terrains_peering_bit/top_left_side = 0
0:2/0/terrains_peering_bit/top_corner = 0
0:2/0/terrains_peering_bit/top_right_side = 0
0:3/0 = 0
0:3/0/terrain_set = 0
0:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:3/0/physics_layer_0/angular_velocity = 0.0
2:0/0 = 0
2:0/0/terrain_set = 0
2:0/0/terrain = 0
2:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:0/0/physics_layer_0/angular_velocity = 0.0
2:0/0/terrains_peering_bit/bottom_right_side = 0
2:0/0/terrains_peering_bit/bottom_corner = 0
2:0/0/terrains_peering_bit/bottom_left_side = 0
2:0/0/terrains_peering_bit/left_corner = 0
2:0/0/terrains_peering_bit/top_left_side = 0
2:1/0 = 0
2:1/0/terrain_set = 0
2:1/0/terrain = 0
2:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:1/0/physics_layer_0/angular_velocity = 0.0
2:1/0/terrains_peering_bit/bottom_left_side = 0
2:1/0/terrains_peering_bit/left_corner = 0
2:1/0/terrains_peering_bit/top_left_side = 0
2:2/0 = 0
2:2/0/terrain_set = 0
2:2/0/terrain = 0
2:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:2/0/physics_layer_0/angular_velocity = 0.0
2:2/0/terrains_peering_bit/bottom_left_side = 0
2:2/0/terrains_peering_bit/left_corner = 0
2:2/0/terrains_peering_bit/top_left_side = 0
2:2/0/terrains_peering_bit/top_corner = 0
2:2/0/terrains_peering_bit/top_right_side = 0
1:2/0 = 0
1:2/0/terrain_set = 0
1:2/0/terrain = 0
1:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:2/0/physics_layer_0/angular_velocity = 0.0
1:2/0/terrains_peering_bit/top_left_side = 0
1:2/0/terrains_peering_bit/top_corner = 0
1:2/0/terrains_peering_bit/top_right_side = 0
1:3/0 = 0
1:3/0/terrain_set = 0
1:3/0/terrain = 0
1:3/0/probability = 0.2
1:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:3/0/physics_layer_0/angular_velocity = 0.0
1:3/0/terrains_peering_bit/right_corner = 0
1:3/0/terrains_peering_bit/bottom_right_side = 0
1:3/0/terrains_peering_bit/bottom_corner = 0
1:3/0/terrains_peering_bit/bottom_left_side = 0
1:3/0/terrains_peering_bit/left_corner = 0
1:3/0/terrains_peering_bit/top_left_side = 0
1:3/0/terrains_peering_bit/top_corner = 0
1:3/0/terrains_peering_bit/top_right_side = 0
2:3/0 = 0
2:3/0/terrain_set = 0
2:3/0/terrain = 0
2:3/0/probability = 0.2
2:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:3/0/physics_layer_0/angular_velocity = 0.0
2:3/0/terrains_peering_bit/right_corner = 0
2:3/0/terrains_peering_bit/bottom_right_side = 0
2:3/0/terrains_peering_bit/bottom_corner = 0
2:3/0/terrains_peering_bit/bottom_left_side = 0
2:3/0/terrains_peering_bit/left_corner = 0
2:3/0/terrains_peering_bit/top_left_side = 0
2:3/0/terrains_peering_bit/top_corner = 0
2:3/0/terrains_peering_bit/top_right_side = 0
2:4/0 = 0
2:4/0/terrain_set = 0
2:4/0/terrain = 0
2:4/0/probability = 0.01
2:4/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:4/0/physics_layer_0/angular_velocity = 0.0
2:4/0/terrains_peering_bit/right_corner = 0
2:4/0/terrains_peering_bit/bottom_right_side = 0
2:4/0/terrains_peering_bit/bottom_corner = 0
2:4/0/terrains_peering_bit/bottom_left_side = 0
2:4/0/terrains_peering_bit/left_corner = 0
2:4/0/terrains_peering_bit/top_left_side = 0
2:4/0/terrains_peering_bit/top_corner = 0
2:4/0/terrains_peering_bit/top_right_side = 0
2:5/0 = 0
2:5/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:5/0/physics_layer_0/angular_velocity = 0.0
2:6/0 = 0
2:6/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:6/0/physics_layer_0/angular_velocity = 0.0

[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_alqgh"]
texture = ExtResource("3_gtmqh")
texture_region_size = Vector2i(64, 64)
0:0/0 = 0
0:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:0/0/physics_layer_0/angular_velocity = 0.0
0:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-34.5, -17, -34, 2, 0, 19, 33, 3, 34, -18, 0, -35)
1:0/0 = 0
1:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:0/0/physics_layer_0/angular_velocity = 0.0
1:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(0, -16, -32, 0, 0, 16, 32, 0)
2:0/0 = 0
2:0/0/z_index = 1
2:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:0/0/physics_layer_0/angular_velocity = 0.0
3:0/0 = 0
3:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
3:0/0/physics_layer_0/angular_velocity = 0.0
0:1/0 = 0
0:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:1/0/physics_layer_0/angular_velocity = 0.0
1:1/0 = 0
1:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:1/0/physics_layer_0/angular_velocity = 0.0
2:1/0 = 0
2:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:1/0/physics_layer_0/angular_velocity = 0.0
3:1/0 = 0
3:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
3:1/0/physics_layer_0/angular_velocity = 0.0
3:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(1, -32.5, -31, -16.5, -32, 0, 0, 16, 32, 0, 31.5, -17)
0:2/0 = 0
0:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:2/0/physics_layer_0/angular_velocity = 0.0
1:2/0 = 0
1:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:2/0/physics_layer_0/angular_velocity = 0.0
2:2/0 = 0
2:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:2/0/physics_layer_0/angular_velocity = 0.0

[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_jple6"]
texture = ExtResource("4_efs67")
texture_region_size = Vector2i(64, 32)
0:0/0 = 0
0:0/0/terrain_set = 0
0:0/0/terrain = 1
0:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:0/0/physics_layer_0/angular_velocity = 0.0
0:0/0/terrains_peering_bit/right_corner = 1
0:0/0/terrains_peering_bit/bottom_right_side = 1
0:0/0/terrains_peering_bit/bottom_corner = 1
0:0/0/terrains_peering_bit/bottom_left_side = 1
0:0/0/terrains_peering_bit/top_right_side = 1
1:0/0 = 0
1:0/0/terrain_set = 0
1:0/0/terrain = 1
1:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:0/0/physics_layer_0/angular_velocity = 0.0
1:0/0/terrains_peering_bit/bottom_right_side = 1
1:0/0/terrains_peering_bit/bottom_corner = 1
1:0/0/terrains_peering_bit/bottom_left_side = 1
2:0/0 = 0
2:0/0/terrain_set = 0
2:0/0/terrain = 1
2:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:0/0/physics_layer_0/angular_velocity = 0.0
2:0/0/terrains_peering_bit/bottom_right_side = 1
2:0/0/terrains_peering_bit/bottom_corner = 1
2:0/0/terrains_peering_bit/bottom_left_side = 1
2:0/0/terrains_peering_bit/left_corner = 1
2:0/0/terrains_peering_bit/top_left_side = 1
0:1/0 = 0
0:1/0/terrain_set = 0
0:1/0/terrain = 1
0:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:1/0/physics_layer_0/angular_velocity = 0.0
0:1/0/terrains_peering_bit/right_corner = 1
0:1/0/terrains_peering_bit/bottom_right_side = 1
0:1/0/terrains_peering_bit/top_right_side = 1
1:1/0 = 0
1:1/0/terrain_set = 0
1:1/0/terrain = 1
1:1/0/probability = 0.2
1:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:1/0/physics_layer_0/angular_velocity = 0.0
1:1/0/terrains_peering_bit/right_corner = 1
1:1/0/terrains_peering_bit/bottom_right_side = 1
1:1/0/terrains_peering_bit/bottom_corner = 1
1:1/0/terrains_peering_bit/bottom_left_side = 1
1:1/0/terrains_peering_bit/left_corner = 1
1:1/0/terrains_peering_bit/top_left_side = 1
1:1/0/terrains_peering_bit/top_corner = 1
1:1/0/terrains_peering_bit/top_right_side = 1
2:1/0 = 0
2:1/0/terrain_set = 0
2:1/0/terrain = 1
2:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:1/0/physics_layer_0/angular_velocity = 0.0
2:1/0/terrains_peering_bit/bottom_left_side = 1
2:1/0/terrains_peering_bit/left_corner = 1
2:1/0/terrains_peering_bit/top_left_side = 1
0:2/0 = 0
0:2/0/terrain_set = 0
0:2/0/terrain = 1
0:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:2/0/physics_layer_0/angular_velocity = 0.0
0:2/0/terrains_peering_bit/right_corner = 1
0:2/0/terrains_peering_bit/bottom_right_side = 1
0:2/0/terrains_peering_bit/top_left_side = 1
0:2/0/terrains_peering_bit/top_corner = 1
0:2/0/terrains_peering_bit/top_right_side = 1
1:2/0 = 0
1:2/0/terrain_set = 0
1:2/0/terrain = 1
1:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:2/0/physics_layer_0/angular_velocity = 0.0
1:2/0/terrains_peering_bit/top_left_side = 1
1:2/0/terrains_peering_bit/top_corner = 1
1:2/0/terrains_peering_bit/top_right_side = 1
2:2/0 = 0
2:2/0/terrain_set = 0
2:2/0/terrain = 1
2:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:2/0/physics_layer_0/angular_velocity = 0.0
2:2/0/terrains_peering_bit/bottom_left_side = 1
2:2/0/terrains_peering_bit/left_corner = 1
2:2/0/terrains_peering_bit/top_left_side = 1
2:2/0/terrains_peering_bit/top_corner = 1
2:2/0/terrains_peering_bit/top_right_side = 1
0:3/0 = 0
0:3/0/terrain_set = 0
0:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:3/0/physics_layer_0/angular_velocity = 0.0
1:3/0 = 0
1:3/0/terrain_set = 0
1:3/0/terrain = 1
1:3/0/probability = 0.2
1:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:3/0/physics_layer_0/angular_velocity = 0.0
1:3/0/terrains_peering_bit/right_corner = 1
1:3/0/terrains_peering_bit/bottom_right_side = 1
1:3/0/terrains_peering_bit/bottom_corner = 1
1:3/0/terrains_peering_bit/bottom_left_side = 1
1:3/0/terrains_peering_bit/left_corner = 1
1:3/0/terrains_peering_bit/top_left_side = 1
1:3/0/terrains_peering_bit/top_corner = 1
1:3/0/terrains_peering_bit/top_right_side = 1
2:3/0 = 0
2:3/0/terrain_set = 0
2:3/0/terrain = 1
2:3/0/probability = 0.2
2:3/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:3/0/physics_layer_0/angular_velocity = 0.0
2:3/0/terrains_peering_bit/right_corner = 1
2:3/0/terrains_peering_bit/bottom_right_side = 1
2:3/0/terrains_peering_bit/bottom_corner = 1
2:3/0/terrains_peering_bit/bottom_left_side = 1
2:3/0/terrains_peering_bit/left_corner = 1
2:3/0/terrains_peering_bit/top_left_side = 1
2:3/0/terrains_peering_bit/top_corner = 1
2:3/0/terrains_peering_bit/top_right_side = 1
2:4/0 = 0
2:4/0/terrain_set = 0
2:4/0/terrain = 1
2:4/0/probability = 0.19
2:4/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:4/0/physics_layer_0/angular_velocity = 0.0
2:4/0/terrains_peering_bit/right_corner = 1
2:4/0/terrains_peering_bit/bottom_right_side = 1
2:4/0/terrains_peering_bit/bottom_corner = 1
2:4/0/terrains_peering_bit/bottom_left_side = 1
2:4/0/terrains_peering_bit/left_corner = 1
2:4/0/terrains_peering_bit/top_left_side = 1
2:4/0/terrains_peering_bit/top_corner = 1
2:4/0/terrains_peering_bit/top_right_side = 1
2:5/0 = 0
2:5/0/terrain_set = 0
2:5/0/terrain = 1
2:5/0/probability = 0.01
2:5/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:5/0/physics_layer_0/angular_velocity = 0.0
2:5/0/terrains_peering_bit/right_corner = 1
2:5/0/terrains_peering_bit/bottom_right_side = 1
2:5/0/terrains_peering_bit/bottom_corner = 1
2:5/0/terrains_peering_bit/bottom_left_side = 1
2:5/0/terrains_peering_bit/left_corner = 1
2:5/0/terrains_peering_bit/top_left_side = 1
2:5/0/terrains_peering_bit/top_corner = 1
2:5/0/terrains_peering_bit/top_right_side = 1
2:6/0 = 0
2:6/0/terrain_set = 0
2:6/0/terrain = 1
2:6/0/probability = 0.2
2:6/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:6/0/physics_layer_0/angular_velocity = 0.0
2:6/0/terrains_peering_bit/right_corner = 1
2:6/0/terrains_peering_bit/bottom_right_side = 1
2:6/0/terrains_peering_bit/bottom_corner = 1
2:6/0/terrains_peering_bit/bottom_left_side = 1
2:6/0/terrains_peering_bit/left_corner = 1
2:6/0/terrains_peering_bit/top_left_side = 1
2:6/0/terrains_peering_bit/top_corner = 1
2:6/0/terrains_peering_bit/top_right_side = 1

[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_djfqb"]
texture = ExtResource("5_rqtvc")
texture_region_size = Vector2i(64, 64)
0:0/0 = 0
0:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:0/0/physics_layer_0/angular_velocity = 0.0
0:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-34.5, -17, -34, 2, 0, 19, 33, 3, 34, -18, 0, -35)
1:0/0 = 0
1:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:0/0/physics_layer_0/angular_velocity = 0.0
2:0/0 = 0
2:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:0/0/physics_layer_0/angular_velocity = 0.0
2:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-0.280613, -32.5514, -32, -16, -32, 0, 0, 16, 32, 0, 32, -16)
3:0/0 = 0
3:0/0/physics_layer_0/linear_velocity = Vector2(0, 0)
3:0/0/physics_layer_0/angular_velocity = 0.0
0:1/0 = 0
0:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:1/0/physics_layer_0/angular_velocity = 0.0
1:1/0 = 0
1:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:1/0/physics_layer_0/angular_velocity = 0.0
2:1/0 = 0
2:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:1/0/physics_layer_0/angular_velocity = 0.0
3:1/0 = 0
3:1/0/physics_layer_0/linear_velocity = Vector2(0, 0)
3:1/0/physics_layer_0/angular_velocity = 0.0
0:2/0 = 0
0:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
0:2/0/physics_layer_0/angular_velocity = 0.0
1:2/0 = 0
1:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
1:2/0/physics_layer_0/angular_velocity = 0.0
2:2/0 = 0
2:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
2:2/0/physics_layer_0/angular_velocity = 0.0
3:2/0 = 0
3:2/0/physics_layer_0/linear_velocity = Vector2(0, 0)
3:2/0/physics_layer_0/angular_velocity = 0.0

[sub_resource type="TileSet" id="TileSet_42v73"]
tile_shape = 1
tile_layout = 4
tile_size = Vector2i(64, 32)
physics_layer_0/collision_layer = 1
terrain_set_0/mode = 0
terrain_set_0/terrain_0/name = "Cave Ground"
terrain_set_0/terrain_0/color = Color(0.235294, 0.396078, 0.239216, 1)
terrain_set_0/terrain_1/name = "Fungus Ground"
terrain_set_0/terrain_1/color = Color(0.772549, 0.168627, 0.34902, 1)
sources/0 = SubResource("TileSetAtlasSource_yqjvn")
sources/1 = SubResource("TileSetAtlasSource_alqgh")
sources/2 = SubResource("TileSetAtlasSource_jple6")
sources/3 = SubResource("TileSetAtlasSource_djfqb")

[sub_resource type="CircleShape2D" id="CircleShape2D_4noh4"]
radius = 8.0

[sub_resource type="CircleShape2D" id="CircleShape2D_b827w"]
radius = 8.0

[node name="Dungeon" type="Node2D"]
scale = Vector2(0.5, 0.5)
script = ExtResource("1_ifql2")

[node name="TileMap" type="TileMap" parent="."]
show_behind_parent = true
y_sort_enabled = true
texture_filter = 1
tile_set = SubResource("TileSet_42v73")
format = 2
layer_0/name = "Ground"
layer_0/y_sort_enabled = true

[node name="GUI" type="CanvasLayer" parent="."]

[node name="Pause_Menu" parent="GUI" instance=ExtResource("13_cipy3")]
offset_left = -1.25
offset_top = -1.25
offset_right = -1.25
offset_bottom = -1.25

[node name="Current_Floor" type="Label" parent="GUI"]
anchors_preset = 3
anchor_left = 1.0
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = -145.0
offset_top = -26.0
grow_horizontal = 0
grow_vertical = 0
text = "Current Floor Here"

[node name="Inventory_gui" parent="GUI" instance=ExtResource("13_87dgk")]
visible = false

[node name="Debug_Hud" type="CanvasLayer" parent="."]
script = ExtResource("6_grh6y")

[node name="Seed" type="Label" parent="Debug_Hud"]
offset_left = 9.0
offset_top = 15.0
offset_right = 333.0
offset_bottom = 67.0
text = "ERROR: this label isn't 
reading the script :/"

[node name="New Seed" type="Button" parent="Debug_Hud/Seed"]
layout_mode = 0
offset_left = 2.0
offset_top = 105.0
offset_right = 87.0
offset_bottom = 136.0
text = "New Seed"

[node name="out_zoom" type="TextureButton" parent="Debug_Hud"]
offset_left = 22.0
offset_top = 160.0
offset_right = 36.0
offset_bottom = 174.0
scale = Vector2(2, 2)

[node name="zoom_out" type="Sprite2D" parent="Debug_Hud/out_zoom"]
position = Vector2(6, 6)
texture = ExtResource("6_jqwbb")
hframes = 4

[node name="in_zoom" type="TextureButton" parent="Debug_Hud"]
offset_left = 60.0
offset_top = 160.0
offset_right = 74.0
offset_bottom = 174.0
scale = Vector2(2, 2)

[node name="zoom_in" type="Sprite2D" parent="Debug_Hud/in_zoom"]
position = Vector2(6, 6)
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 1

[node name="left" type="TextureButton" parent="Debug_Hud"]
offset_left = 13.0
offset_top = 225.0
offset_right = 27.0
offset_bottom = 239.0
scale = Vector2(2, 2)

[node name="arrow" type="Sprite2D" parent="Debug_Hud/left"]
position = Vector2(7, 7)
rotation = 4.71239
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 2

[node name="right" type="TextureButton" parent="Debug_Hud"]
offset_left = 69.0
offset_top = 225.0
offset_right = 83.0
offset_bottom = 239.0
scale = Vector2(2, 2)

[node name="arrow" type="Sprite2D" parent="Debug_Hud/right"]
position = Vector2(7, 7)
rotation = 1.5708
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 2

[node name="back" type="TextureButton" parent="Debug_Hud"]
offset_left = 39.0
offset_top = 294.0
offset_right = 55.0
offset_bottom = 309.0
scale = Vector2(2, 2)

[node name="return" type="Sprite2D" parent="Debug_Hud/back"]
position = Vector2(8, 7)
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 3

[node name="up" type="TextureButton" parent="Debug_Hud"]
offset_left = 41.0
offset_top = 197.0
offset_right = 55.0
offset_bottom = 211.0
scale = Vector2(2, 2)

[node name="arrow" type="Sprite2D" parent="Debug_Hud/up"]
position = Vector2(7, 7)
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 2

[node name="down" type="TextureButton" parent="Debug_Hud"]
offset_left = 41.0
offset_top = 253.0
offset_right = 55.0
offset_bottom = 267.0
scale = Vector2(2, 2)

[node name="arrow" type="Sprite2D" parent="Debug_Hud/down"]
position = Vector2(7, 7)
rotation = 3.14159
texture = ExtResource("6_jqwbb")
hframes = 4
frame = 2

[node name="shake" type="Button" parent="Debug_Hud"]
offset_left = 27.0
offset_top = 328.0
offset_right = 82.0
offset_bottom = 364.0
text = "Shake
"

[node name="CanvasLayer" type="CanvasLayer" parent="Debug_Hud"]
layer = 0

[node name="HeartsContainer" parent="Debug_Hud" instance=ExtResource("6_tho0w")]
offset_left = 69.0
offset_top = 24.0
offset_right = 281.0
offset_bottom = 117.0

[node name="Cassandra" parent="." instance=ExtResource("11_ai3vm")]

[node name="Staircase" type="StaticBody2D" parent="."]

[node name="Sprite2D" type="Sprite2D" parent="Staircase"]
texture = ExtResource("2_nq54f")
hframes = 3
vframes = 10
frame = 13

[node name="CollisionShape2D" type="CollisionShape2D" parent="Staircase"]
visible = false
shape = SubResource("CircleShape2D_4noh4")

[node name="Staircase_hitbox" type="Area2D" parent="Staircase"]

[node name="CollisionShape2D" type="CollisionShape2D" parent="Staircase/Staircase_hitbox"]
visible = false
shape = SubResource("CircleShape2D_b827w")

[node name="BackgroundSound" type="AudioStreamPlayer" parent="."]
stream = ExtResource("13_7lc74")
script = ExtResource("14_1o1d0")

[node name="Potion1" parent="." instance=ExtResource("14_4maq5")]

[connection signal="pressed" from="Debug_Hud/Seed/New Seed" to="." method="_on_new_seed_pressed"]
[connection signal="pressed" from="Debug_Hud/out_zoom" to="Debug_Hud" method="_on_out_zoom_pressed"]
[connection signal="pressed" from="Debug_Hud/in_zoom" to="Debug_Hud" method="_on_in_zoom_pressed"]
[connection signal="pressed" from="Debug_Hud/left" to="Debug_Hud" method="_on_left_pressed"]
[connection signal="pressed" from="Debug_Hud/right" to="Debug_Hud" method="_on_right_pressed"]
[connection signal="pressed" from="Debug_Hud/back" to="Debug_Hud" method="_on_back_pressed"]
[connection signal="pressed" from="Debug_Hud/up" to="Debug_Hud" method="_on_up_pressed"]
[connection signal="pressed" from="Debug_Hud/down" to="Debug_Hud" method="_on_down_pressed"]
[connection signal="pressed" from="Debug_Hud/shake" to="Debug_Hud" method="_on_shake_pressed"]
[connection signal="area_entered" from="Staircase/Staircase_hitbox" to="." method="_on_staircase_hitbox_area_entered"]
