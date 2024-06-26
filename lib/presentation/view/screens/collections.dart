import 'package:flutter/material.dart';

List<String> avatars = [
  "https://cdn-icons-png.freepik.com/256/945/945260.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/952/952936.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/4333/4333642.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/13847/13847433.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/11195/11195353.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/11696/11696670.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/11045/11045308.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1050/1050444.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/190/190609.png?ga=GA1.1.1670387391.1711524050&",
  //
  "https://cdn-icons-png.freepik.com/256/190/190639.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/4453/4453609.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1881/1881006.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/4058/4058940.png?ga=GA1.1.1670387391.1711524050&",
  //
  "https://cdn-icons-png.freepik.com/256/4807/4807976.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/5084/5084596.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/8710/8710562.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/6819/6819742.png?ga=GA1.1.1670387391.1711524050&",
  //
  "https://cdn-icons-png.freepik.com/256/2202/2202112.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/607/607381.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/11696/11696660.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/6276/6276024.png?ga=GA1.1.1670387391.1711524050&",
  //
  "https://cdn-icons-png.freepik.com/256/15200/15200122.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1912/1912058.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/13374/13374988.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/8132/8132880.png?ga=GA1.1.1670387391.1711524050&",
  //
  "https://cdn-icons-png.freepik.com/256/2632/2632546.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/10888/10888874.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/6714/6714044.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1805/1805732.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/2173/2173478.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/2172/2172021.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/616/616412.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/2002/2002974.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/7519/7519424.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/10104/10104222.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/11975/11975769.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/3558/3558927.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/630/630426.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/4490/4490425.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/7316/7316717.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1352/1352462.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/7040/7040020.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/136/136090.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/3891/3891577.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/4140/4140048.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/8271/8271336.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/9508/9508789.png?ga=GA1.1.1670387391.1711524050&",
  "https://cdn-icons-png.freepik.com/256/1776/1776700.png?ga=GA1.1.1670387391.1711524050&",
];

Color g = Color.fromARGB(255, 0, 0, 0);
Color v = Color(0XFFC27EEB);
