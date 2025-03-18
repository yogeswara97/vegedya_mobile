import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ? _obscureText : false,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 38, 13, 1),
              width: 2,
            ),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }, 
                )
              : null
        ),
      ),
    );
  }
}
