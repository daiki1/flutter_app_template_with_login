import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import 'form_section.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? label;
  final RxList<T> items;
  final Rx<T?> selectedItem;
  final String Function(T) itemLabel;
  final String? hintText;
  final void Function(T?) onChanged;
  final bool enableSearch;
  final RxBool? hasMoreItems;
  final VoidCallback? onLoadMoreItems;

  const CustomDropdown({
    super.key,
    this.label,
    required this.items,
    required this.selectedItem,
    required this.itemLabel,
    required this.onChanged,
    this.hintText,
    this.enableSearch = false,
    this.hasMoreItems,
    this.onLoadMoreItems
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final RxBool isOpen = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    Widget loadMoreItems() {
      if (widget.hasMoreItems?.value??false) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CustomButton(
            onPressed: () async {
              widget.onLoadMoreItems?.call();
            },
            label: 'load_more_items'.tr,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return Obx(() {
      final filteredItems = widget.enableSearch && searchQuery.value.isNotEmpty
          ? widget.items
          .where((item) => widget
          .itemLabel(item)
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
          .toList()
          : widget.items;

      final selectedLabel = widget.selectedItem.value != null
          ? widget.itemLabel(widget.selectedItem.value as T)
          : null;

      return FormSection(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    isOpen.value = !isOpen.value;
                    if (!isOpen.value) searchQuery.value = '';
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedLabel ?? widget.hintText?? 'select_item'.tr,
                            style: TextStyle(
                              color: selectedLabel == null
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          isOpen.value
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isOpen.value)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: Column(
                      children: [
                        if (widget.enableSearch)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: TextField(
                              onChanged: (val) => searchQuery.value = val,
                              decoration: InputDecoration(
                                hintText: 'search'.tr,
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                              ),
                            ),
                          ),
                        Expanded(
                          child: filteredItems.isEmpty
                              ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'no_items_found'.tr,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                loadMoreItems(),
                              ],
                            ),
                          )
                              : ListView.builder(
                            itemCount: filteredItems.length + 1, // One extra for Load More
                            itemBuilder: (context, index) {
                              if (index < filteredItems.length) {
                                final item = filteredItems[index];
                                final label = widget.itemLabel(item);
                                final isSelected = item == widget.selectedItem.value;
                                return InkWell(
                                  onTap: () {
                                    widget.onChanged(item);
                                    isOpen.value = false;
                                    searchQuery.value = '';
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Last item: Load more
                                return loadMoreItems();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(' '),
              ],
            ),
            if ((widget.selectedItem.value != null || isOpen.value) && widget.label != null)
              Positioned(
                left: 12,
                top: -8, // Slightly above the border line
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: Colors.white, // Match the dropdown background
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}