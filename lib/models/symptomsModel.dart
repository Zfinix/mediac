class SymptomsModel {
	List<Data> data;

	SymptomsModel({this.data});

	SymptomsModel.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<Data>();
			json['data'].forEach((v) { data.add(new Data.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Data {
	String id;
	String name;
	String commonName;
	String sexFilter;
	String category;
	String seriousness;
	List<dynamic> children;
	var imageUrl;
	var imageSource;
	var parentId;
	var parentRelation;

	Data({this.id, this.name, this.commonName, this.sexFilter, this.category, this.seriousness, this.children, this.imageUrl, this.imageSource, this.parentId, this.parentRelation});

	Data.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		commonName = json['common_name'];
		sexFilter = json['sex_filter'];
		category = json['category'];
		seriousness = json['seriousness'];
		imageUrl = json['image_url'];
		imageSource = json['image_source'];
		parentId = json['parent_id'];
		parentRelation = json['parent_relation'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['name'] = this.name;
		data['common_name'] = this.commonName;
		data['sex_filter'] = this.sexFilter;
		data['category'] = this.category;
		data['seriousness'] = this.seriousness;
		data['image_url'] = this.imageUrl;
		data['image_source'] = this.imageSource;
		data['parent_id'] = this.parentId;
		data['parent_relation'] = this.parentRelation;
		return data;
	}
}
