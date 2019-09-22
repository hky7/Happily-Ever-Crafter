extends Node

var resources = game_controller.reference_data.resources;
var tailorIcon = preload("res://assets/sprites/tailor_icon.png");
var blacksmithIcon = preload("res://assets/sprites/blacksmith_icon.png");
var jewelerIcon = preload("res://assets/sprites/jeweler_icon.png");
var leatherworkerIcon = preload("res://assets/sprites/leatherworker_icon.png");
var cookingIcon = preload("res://assets/sprites/cooking_icon.png");
var alchemistIcon = preload("res://assets/sprites/alchemist_icon.png");

func _ready():
	var resourceGrid = get_node('resource_grid')
	var resourceScene = load('res://object_templates/resource_amount.tscn')
	
	for resource in resources:
		var instancedResource = resourceScene.instance()
		instancedResource.get_node('rsr_amt_lbl').set_text('1.5k')
		instancedResource.get_node('rsr_img').set_texture(_get_texture(resource.resource_name))
		
		resourceGrid.add_child(instancedResource)

func _get_texture(resource):
	match resource:
		'Wool', 'Linen', 'Silk', 'Spider Silk':
			return tailorIcon
		'Iron', 'Steel', 'Damascus Steel', 'Mithril':
			return blacksmithIcon
		'Herbs', 'Arcanum', 'Aqua Vitae', 'Alkahest':
			return alchemistIcon
		'Light Hide', 'Medium Hide', 'Heavy Hide', 'Dragon Hide':
			return leatherworkerIcon
		'Water', 'Honey', 'Olive Oil', 'Exotic Spices':
			return cookingIcon
		'Silver', 'Gold', 'Crystal', 'Gem':
			return jewelerIcon