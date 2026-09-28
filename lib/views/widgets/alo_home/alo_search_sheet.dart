import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../utils/values/my_color.dart';

enum _SearchPanel { whereFrom, whereTo, when, who }

/// Airbnb-style full planner sheet — From / To / Dates / People.
class AloSearchSheet extends StatefulWidget {
  const AloSearchSheet({super.key, this.initial});

  final _SearchPanel? initial;

  static Future<void> show({_SearchPanel? initial}) {
    return Get.bottomSheet(
      AloSearchSheet(initial: initial),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
      enableDrag: true,
    );
  }

  static Future<void> showFrom() => show(initial: _SearchPanel.whereFrom);
  static Future<void> showTo() => show(initial: _SearchPanel.whereTo);
  static Future<void> showWhen() => show(initial: _SearchPanel.when);
  static Future<void> showWho() => show(initial: _SearchPanel.who);

  @override
  State<AloSearchSheet> createState() => _AloSearchSheetState();
}

class _AloSearchSheetState extends State<AloSearchSheet> {
  late _SearchPanel _open;
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;
  final _fromFocus = FocusNode();
  final _toFocus = FocusNode();

  HomeController get c => Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _open = widget.initial ?? _SearchPanel.whereTo;
    _fromCtrl = TextEditingController(text: c.searchFrom.value);
    _toCtrl = TextEditingController(text: c.searchTo.value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_open == _SearchPanel.whereFrom) _fromFocus.requestFocus();
      if (_open == _SearchPanel.whereTo) _toFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _fromFocus.dispose();
    _toFocus.dispose();
    super.dispose();
  }

  void _select(_SearchPanel p) {
    setState(() => _open = p);
    if (p == _SearchPanel.whereFrom) {
      Future.microtask(_fromFocus.requestFocus);
    } else if (p == _SearchPanel.whereTo) {
      Future.microtask(_toFocus.requestFocus);
    } else {
      _fromFocus.unfocus();
      _toFocus.unfocus();
    }
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: c.checkIn.value ?? now.add(const Duration(days: 1)),
        end: c.checkOut.value ?? now.add(const Duration(days: 3)),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.aloForest,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: MyColors.aloText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (range == null) return;
    c.setCheckIn(range.start);
    c.setCheckOut(range.end);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final h = MediaQuery.sizeOf(context).height;

    return Container(
      height: h * 0.94,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: MyColors.borderSubtle,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(Icons.close, color: MyColors.aloText),
                ),
                Expanded(
                  child: Text(
                    'Plan your day',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: MyColors.aloText,
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              children: [
                _ExpandCard(
                  open: _open == _SearchPanel.whereFrom,
                  title: 'Where from?',
                  collapsedValue: c.searchFrom.value,
                  onTap: () => _select(_SearchPanel.whereFrom),
                  child: _PlacePicker(
                    controller: _fromCtrl,
                    focusNode: _fromFocus,
                    hint: 'Current location or a place',
                    suggestions: HomeController.fromSuggestions,
                    onPick: (v) {
                      c.setSearchFrom(v);
                      _fromCtrl.text = v;
                      _select(_SearchPanel.whereTo);
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                _ExpandCard(
                  open: _open == _SearchPanel.whereTo,
                  title: 'Where to?',
                  collapsedValue: c.searchTo.value.isEmpty
                      ? 'Search destinations'
                      : c.searchTo.value,
                  muted: c.searchTo.value.isEmpty,
                  onTap: () => _select(_SearchPanel.whereTo),
                  child: _PlacePicker(
                    controller: _toCtrl,
                    focusNode: _toFocus,
                    hint: 'Red Square, parks, cities…',
                    suggestions: HomeController.toSuggestions,
                    onPick: (v) {
                      c.setSearchTo(v);
                      _toCtrl.text = v;
                      _select(_SearchPanel.when);
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                _ExpandCard(
                  open: _open == _SearchPanel.when,
                  title: 'When?',
                  collapsedValue: c.dateRangeLabel,
                  onTap: () => _select(_SearchPanel.when),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pick check-in and check-out',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: MyColors.aloMuted,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: _DateTile(
                              label: 'Check in',
                              value: c.checkIn.value == null
                                  ? 'Add date'
                                  : '${c.checkIn.value!.day} ${_month(c.checkIn.value!.month)}',
                              onTap: _pickDates,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _DateTile(
                              label: 'Check out',
                              value: c.checkOut.value == null
                                  ? 'Add date'
                                  : '${c.checkOut.value!.day} ${_month(c.checkOut.value!.month)}',
                              onTap: _pickDates,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _select(_SearchPanel.who),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: MyColors.aloForest,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                _ExpandCard(
                  open: _open == _SearchPanel.who,
                  title: 'Who?',
                  collapsedValue: c.guestsLabelSearch,
                  onTap: () => _select(_SearchPanel.who),
                  child: Column(
                    children: [
                      _GuestStepper(
                        title: 'Adults',
                        subtitle: 'Ages 13+',
                        value: c.adults.value,
                        onChanged: (v) {
                          c.setAdults(v);
                          setState(() {});
                        },
                        min: 1,
                      ),
                      Divider(height: 28.h, color: MyColors.borderSubtle),
                      _GuestStepper(
                        title: 'Children',
                        subtitle: 'Ages 2–12',
                        value: c.children.value,
                        onChanged: (v) {
                          c.setChildren(v);
                          setState(() {});
                        },
                      ),
                      Divider(height: 28.h, color: MyColors.borderSubtle),
                      _GuestStepper(
                        title: 'Infants',
                        subtitle: 'Under 2',
                        value: c.infants.value,
                        onChanged: (v) {
                          c.setInfants(v);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    c.setSearchTo('');
                    c.setSearchFrom('Your location · Moscow');
                    c.setAdults(2);
                    c.setChildren(0);
                    c.setInfants(0);
                    final now = DateTime.now();
                    c.setCheckIn(now.add(const Duration(days: 1)));
                    c.setCheckOut(now.add(const Duration(days: 3)));
                    _fromCtrl.text = c.searchFrom.value;
                    _toCtrl.clear();
                    setState(() => _open = _SearchPanel.whereTo);
                  },
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      color: MyColors.aloText,
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: MyColors.aloForest,
                  borderRadius: BorderRadius.circular(28.r),
                  child: InkWell(
                    onTap: () {
                      if (c.searchTo.value.trim().isEmpty) {
                        _select(_SearchPanel.whereTo);
                        return;
                      }
                      Get.back();
                      c.applySearch();
                    },
                    borderRadius: BorderRadius.circular(28.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][m - 1];
}

class _ExpandCard extends StatelessWidget {
  const _ExpandCard({
    required this.open,
    required this.title,
    required this.collapsedValue,
    required this.onTap,
    required this.child,
    this.muted = false,
  });

  final bool open;
  final String title;
  final String collapsedValue;
  final VoidCallback onTap;
  final Widget child;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: open
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: open ? MyColors.aloText : Colors.transparent,
          width: open ? 1.2 : 0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: open ? null : onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(open ? 18.w : 16.w),
            child: open
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: MyColors.aloText,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      child,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.replaceAll('?', ''),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: MyColors.aloMuted,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          collapsedValue,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: muted ? MyColors.aloMuted : MyColors.aloText,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _PlacePicker extends StatelessWidget {
  const _PlacePicker({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.suggestions,
    required this.onPick,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final List<String> suggestions;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: MyColors.aloText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.aloMuted, fontSize: 15.sp),
            prefixIcon: Icon(Icons.search, color: MyColors.aloForest),
            filled: true,
            fillColor: const Color(0xFFF6F6F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) onPick(v.trim());
          },
        ),
        SizedBox(height: 12.h),
        ...suggestions.map(
          (s) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: MyColors.aloMintSoft,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.place_outlined, color: MyColors.aloForest),
            ),
            title: Text(
              s,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: MyColors.aloText,
              ),
            ),
            onTap: () => onPick(s),
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: MyColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: MyColors.aloMuted,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.aloText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestStepper extends StatelessWidget {
  const _GuestStepper({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.min = 0,
  });

  final String title;
  final String subtitle;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.aloText,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13.sp, color: MyColors.aloMuted),
              ),
            ],
          ),
        ),
        _RoundBtn(
          icon: Icons.remove,
          enabled: value > min,
          onTap: () => onChanged(value - 1),
        ),
        SizedBox(
          width: 36.w,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: MyColors.aloText,
            ),
          ),
        ),
        _RoundBtn(
          icon: Icons.add,
          enabled: true,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: MyColors.borderSubtle),
          ),
          child: Icon(icon, size: 18.sp, color: MyColors.aloText),
        ),
      ),
    );
  }
}
