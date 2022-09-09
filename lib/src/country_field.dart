import 'package:all_country_picker/src/utils/country_list.dart';
import 'package:all_country_picker/src/utils/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/input_format.dart';

class CountryField extends StatefulWidget {
  const CountryField({
    super.key,
    required this.phoneNumberController,
    this.keyboardType,
    this.hintText,
    this.hintStyle,
    this.errorStyle,
    this.isCollapsed,
    this.isDense,
    this.inputFormatters,
    this.style,
    this.countryList,
    this.onDropdownChanged,
    this.flagHeight,
    this.flagWidth,
    this.countryCodeTextStyle,
  });
  final TextEditingController phoneNumberController;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? style;
  final bool? isCollapsed;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(CountryModel?)? onDropdownChanged;
  final double? flagHeight;
  final double? flagWidth;
  final TextStyle? countryCodeTextStyle;

  ///Only supports iso code
  final List<String>? countryList;

  @override
  State<CountryField> createState() => _CountryFieldState();
}

class _CountryFieldState extends State<CountryField> {
  List<DropdownMenuItem<CountryModel>>? countryItem;
  final CountryList countryList = CountryList();
  CountryModel? countryModel;

  @override
  void initState() {
    if (widget.countryList != null && widget.countryList!.isNotEmpty) {
      countryItem = getCountryItems(widget.countryList!);
    } else {
      countryItem = getCountryItems([]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.phoneNumberController,
      keyboardType: widget.keyboardType ?? TextInputType.phone,
      inputFormatters: [
        TextInputMask(
          mask: countryModel?.hint.replaceAll(RegExp(r'[0-9]'), '9'),
          reverse: false,
        ),
      ],
      style: widget.style,
      decoration: InputDecoration(
        hintText: widget.hintText ?? countryModel?.hint,
        hintStyle: widget.hintStyle ??
            TextStyle(
              color: Colors.grey.withOpacity(0.5),
            ),
        errorStyle: widget.errorStyle,
        isCollapsed: widget.isCollapsed ?? false,
        isDense: widget.isDense,
        prefixIcon: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CountryModel>(
              iconSize: 18,
              items: countryItem,
              value: countryModel,
              onChanged: (value) {
                setState(() {
                  countryModel = value!;
                });
                debugPrint("Country Name : ${value!.name.toString()}");
                debugPrint("Country Code : ${value.countryCode.toString()}");
                debugPrint("ISO Code : ${value.isoCode.toString()}");
                debugPrint("Placeholder : ${value.hint.toString()}");
                if (widget.onDropdownChanged != null) {
                  widget.onDropdownChanged!(value);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<CountryModel>> getCountryItems(List<String> list) {
    List<DropdownMenuItem<CountryModel>> items = [];
    List<CountryModel> filterList = [];

    if (list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        filterList.addAll(countryList.countryList.where((element) {
          return list[i].toString().toLowerCase() ==
              element.isoCode.toLowerCase();
        }).toList());
      }
      filterList = filterList.toSet().toList();

      setState(() {
        countryModel = filterList[0];
      });

      for (CountryModel model in filterList) {
        items.add(
          DropdownMenuItem(
            value: model,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  model.flag,
                  height: widget.flagHeight ?? 20,
                  width: widget.flagWidth ?? 30,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                  package: 'all_country_picker',
                ),
                const SizedBox(width: 5),
                Text(
                  "+${model.countryCode}",
                  style: widget.countryCodeTextStyle ??
                      const TextStyle(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      filterList = countryList.countryList;
      filterList = filterList.toSet().toList();
      setState(() {
        countryModel = filterList[0];
      });
      for (CountryModel model in filterList) {
        items.add(
          DropdownMenuItem(
            value: model,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  model.flag,
                  height: widget.flagHeight ?? 20,
                  width: widget.flagWidth ?? 30,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                  package: 'all_country_picker',
                ),
                const SizedBox(width: 5),
                Text(
                  "+${model.countryCode}",
                  style: widget.countryCodeTextStyle ??
                      const TextStyle(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return items;
  }
}
