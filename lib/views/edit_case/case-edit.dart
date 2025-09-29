import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/xwidgets/xtext.dart';
import 'package:justice/views/edit_case/EditScreenControllerTags.dart';
import '../../res/navigation_service/NavigatorService.dart';
import '../create_case/link-case-controller.dart';
import '../../models/case-model.dart';
import '../../models/contact-model.dart';
import '../../res/xwidgets/xtextfield.dart';
import 'case-edit-controller.dart';

class CaseEditScreen extends StatelessWidget {
  late CaseEditController controller;
  late LinkCaseController linkCaseController;
  final CaseModel kase;

  CaseEditScreen({super.key, required this.kase});

  _init(){
    var tags = EditScreenControllerTags();
    linkCaseController = Get.put(LinkCaseController(), tag: tags.linkCase);
    controller = Get.put(CaseEditController(), tag: tags.editCase);
  }

  @override
  Widget build(BuildContext context) {
    _init();
    controller.initializeWithCase(kase);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(didPop) return;
        await controller.goback();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7FAFC),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Edit Case',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
        onPressed: () => controller.goback(),
      ),
      actions: [
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: Icon(Icons.delete_outline, color: Colors.red),
      onPressed: controller.deleteCase,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Basic Information Section
          _buildSection(
            title: 'Basic Information',
            children: [
              _buildTextField(
                label: 'Case Title *',
                hint: 'Enter case title',
                value: controller.title.value,
                onChanged: (value) => controller.title.value = value,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Case Number',
                hint: 'Enter case number (optional)',
                value: controller.caseNumber.value,
                onChanged: (value) => controller.caseNumber.value = value,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Proceedings Details',
                hint: 'Enter proceedings details',
                value: controller.proceedingsDetails.value,
                onChanged: (value) => controller.proceedingsDetails.value = value,
                maxLines: 3,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Court Information Section
          _buildSection(
            title: 'Court Information',
            children: [
              _buildTextField(
                label: 'Court',
                hint: 'Enter court type',
                value: controller.court.value,
                onChanged: (value) => controller.court.value = value,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'City',
                hint: 'Enter city',
                value: controller.city.value,
                onChanged: (value) => controller.city.value = value,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Case Details Section
          _buildSection(
            title: 'Case Details',
            children: [
              _buildDropdown(
                label: 'Case Stage *',
                value: controller.caseStage.value,
                options: controller.caseStageOptions,
                onChanged: controller.setCaseStage,
              ),
              SizedBox(height: 16),
              _buildDropdown(
                label: 'Case Type',
                value: controller.caseType.value,
                options: controller.caseTypeOptions,
                onChanged: controller.setCaseType,
              ),
              SizedBox(height: 16),
              _buildDropdown(
                label: 'Status',
                value: controller.status.value,
                options: controller.statusOptions,
                onChanged: controller.setStatus,
              ),
              SizedBox(height: 16),
              _buildDropdown(
                label: 'Priority',
                value: controller.priority.value,
                options: controller.priorityOptions,
                onChanged: controller.setPriority,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Hearing Dates Section
          _buildSection(
            title: 'Hearing Dates',
            children: [
              _buildDateField(
                label: 'Previous Hearing Date',
                date: controller.prevDate.value,
                onDateSelected: (date) => controller.prevDate.value = date,
                enabled: false,
              ),
              SizedBox(height: 16),
              _buildDateField(
                label: 'Upcoming Hearing Date',
                date: controller.upcomingDate.value,
                onDateSelected: (date) => controller.upcomingDate.value = date,
                enabled: false,
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: null, child: XText("Edit Hearings")),
                ],
              ),
              // _buildDropdown(
              //   label: 'Date Status',
              //   value: controller.dateStatus.value,
              //   options: controller.dateStatusOptions,
              //   onChanged: controller.setDateStatus,
              // ),
              // SizedBox(height: 16),
              // _buildTextField(
              //   label: 'Date Notes',
              //   hint: 'Add notes about the hearing',
              //   value: controller.dateNotes.value,
              //   onChanged: (value) => controller.dateNotes.value = value,
              //   maxLines: 2,
              // ),
            ],
          ),

          SizedBox(height: 24),

          // Clients Section
          _buildSection(
            title: 'Clients',
            children: [
              _buildClientsSection(),
            ],
          ),

          SizedBox(height: 24),

          // Linked Cases Section
          _buildSection(
            title: 'Linked Cases',
            children: [
              _buildLinkedCasesSection(),
            ],
          ),

          SizedBox(height: 32),

          // Save Button
          _buildSaveButton(),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: TextField(
            onChanged: onChanged,
            controller: TextEditingController(text: value),
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value.isEmpty ? null : value,
            dropdownColor: AppColors.foreground2,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option.capitalizeFirst!),
              );
            }).toList(),
            onChanged: (newValue) => onChanged(newValue!),
            decoration: InputDecoration(
              hintText: 'Select $label',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    DateTime? date,
    required Function(DateTime) onDateSelected,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: ListTile(
            leading: Icon(Icons.calendar_today, color: Color(0xFF1A365D)),
            title: Text(
              date == null ? "Date Not Selected" :
              '${date.day}/${date.month}/${date.year}',
              style: GoogleFonts.poppins(),
            ),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: !enabled ? null : () async {
              final pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                onDateSelected(pickedDate);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClientsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Clients',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            ElevatedButton.icon(
              onPressed: controller.navigateToAddContact,
              icon: Icon(Icons.add, size: 16),
              label: Text('Add Client'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBg,
                foregroundColor: AppColors.buttonForeground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(() => controller.selectedClients.isEmpty
            ? _buildEmptyState('No clients added', Icons.people_outline)
            : Column(
          children: controller.selectedClients
              .map((client) => _buildClientItem(client))
              .toList(),
        )),
      ],
    );
  }

  Widget _buildClientItem(ContactModel client) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF1A365D).withOpacity(0.1),
            child: Icon(Icons.person, color: Color(0xFF1A365D), size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                Text(client.type.capitalizeFirst!, style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF718096))),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red, size: 20),
            onPressed: () => controller.removeClient(client),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedCasesSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Autocomplete(
                key: UniqueKey(),
                textEditingController: linkCaseController.txtController,
                focusNode: linkCaseController.focusNode,
                onSelected: linkCaseController.onSelected,
                optionsBuilder: (value){
                  if (value.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return linkCaseController.cases.where((CaseModel option) {
                    return option.title.toLowerCase().contains(value.text.toLowerCase());
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmitted){
                  return XTextField(
                    controller: controller,
                    focusNode: focusNode,
                    dense: true,
                    verticalContentPadding: 4,
                    borderRadius: 10,
                    hint: "Type Case Title Here",
                    onSubmitted: (value) => onSubmitted(),
                  );
                },
                optionsViewBuilder: (BuildContext context, onSelected, Iterable options) {
                  return Material(
                    color: Colors.white,
                    elevation: 4,
                    child: ListView.builder(
                      key: UniqueKey(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        CaseModel option = options.elementAt(index);
                        return ListTile(
                          title: Text(option.title),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(() => linkCaseController.linkedCases.isEmpty
            ? _buildEmptyState('No linked cases', Icons.link_off)
            : Wrap(
          spacing: 8,
          runSpacing: 8,
          children: linkCaseController.linkedCases
              .map((caseId) => _buildLinkedCaseChip(caseId))
              .toList(),
        )),
      ],
    );
  }

  Widget _buildLinkedCaseChip(CaseModel kase) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFBEE3F8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(kase.title, style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF1A365D))),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () => linkCaseController.removeLinkedCase(kase),
            child: Icon(Icons.close, size: 14, color: Color(0xFF1A365D)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Color(0xFFCBD5E0)),
          SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isSaving.value ? null : controller.saveCase,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBg,
          foregroundColor: AppColors.buttonForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: controller.isSaving.value
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Text(
          'Update Case',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ));
  }
}