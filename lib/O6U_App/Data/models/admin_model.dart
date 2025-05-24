class Admin {
  String email;
  String password;

  Admin({required this.email, required this.password});

  factory Admin.fromJson(Map<String, dynamic> json) {
   return Admin(email: json['email'] ?? '' ,
       password: json['password'] ?? ''
   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}