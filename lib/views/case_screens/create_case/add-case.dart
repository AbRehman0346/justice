import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/views/case_screens/create_case/controller-tags.dart';
import '../../../models/date-model.dart';
import '../../../res/colors/app-colors.dart';
import '../../../res/utils/xutils.dart';
import '../../../temp_data/cases-data.dart';
import '../create_case/link-case-controller.dart';
import '../../../models/case-model.dart';
import '../../../models/contact-model.dart';
import '../../../res/xwidgets/xtextfield.dart';
import '../create_case/add-case-controller.dart';

class AddCaseScreen extends StatelessWidget {
  AddCaseScreen({super.key});

  // TODO: Add Final Here since they don't change...
  late AddCaseController controller;
  late LinkCaseController linkCaseController;

  _init(){
    var tags = AddCaseScreenControllerTags();
    controller = Get.put(AddCaseController(), tag: tags.addCase);
    linkCaseController = Get.put(LinkCaseController(), tag: tags.linkCase);
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(didPop) return;
        bool success = await controller.disposeControllers();
        if(!success){
          Get.snackbar("Error", "Could not delete controllers");
        }
        NavigatorService.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7FAFC),
        appBar: AppBar(
          title: Text('Add New Case', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
            onPressed: () async => await controller.goback(),
          ),
          actions: [
            Obx(() => controller.isLoading.value
                ? Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : IconButton(
              icon: Icon(Icons.save, color: Color(0xFF1A365D)),
              onPressed: controller.saveCase,
            )),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Basic Information'),
              _buildTextField('Case Title *', 'Enter case title', controller.title),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Court *', 'e.g., Supreme Court', controller.court)),
                  SizedBox(width: 12),
                  Expanded(child: _buildTextField('City *', 'e.g., New York', controller.city)),
                ],
              ),

              SizedBox(height: 16),
              _buildTextField('Case Number (Optional)', 'Case reference number', controller.caseNumber),

              SizedBox(height: 24),
              _buildSectionHeader('Case Details'),
              _buildDropdown('Case Status', controller.status.value,
                  controller.statusOptions, controller.setStatus),

              SizedBox(height: 16),
              _buildDropdown('Priority', controller.priority.value,
                  controller.priorityOptions, controller.setPriority),

              SizedBox(height: 16),
              _buildDropdown('Case Stage', controller.caseStage.value,
                  controller.caseStageOptions, controller.setCaseStage),

              SizedBox(height: 16),
              _buildDropdown('Case Type', controller.caseType.value,
                  controller.caseTypeOptions, controller.setCaseType),

              SizedBox(height: 16),
              _buildTextField('Proceedings Details', 'Enter case details and proceedings',
                  controller.proceedingsDetails, maxLines: 4),

              SizedBox(height: 24),
              _buildSectionHeader('Hearing Dates'),
              _buildDateField('Upcoming Date *', controller.upcomingDate.value,
                      (date) => controller.setUpcomingDate(date)),

              SizedBox(height: 16),
              _buildDropdown('Date Status', controller.dateStatus.value,
                  controller.dateStatusOptions, controller.setDateStatus, false),

              SizedBox(height: 16),
              _buildTextField('Date Notes (Optional)', 'Additional notes about the date',
                  controller.dateNotes, maxLines: 2),

              SizedBox(height: 24),
              _buildSectionHeader('Clients'),
              _buildClientsSection(),

              XUtils.height(24),
              _buildSectionHeader('Link Case'),
              _buildLinkedCasesSection(),

              SizedBox(height: 40),
              _buildSaveButton(),
              SizedBox(height: 20),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A365D),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      RxString value,
      {
        int maxLines = 1,
        bool isRequired = false,
        FocusNode? focusNode,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            if (isRequired) Text(' *', style: GoogleFonts.poppins(color: Colors.red)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: TextField(
            focusNode: focusNode,
            onChanged: (text) => value.value = text,
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

  Widget _buildDateField(
      String label,
      DateTime? date,
      Function(DateTime?) onDateSelected,
    ) {

    FocusNode focusNode = FocusNode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: ListTile(
            focusNode: focusNode,
            leading: Icon(Icons.calendar_today, color: Color(0xFF1A365D)),
            title: Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Select date',
              style: GoogleFonts.poppins(
                color: date != null ? Color(0xFF1A365D) : Color(0xFFA0AEC0),
              ),
            ),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () async {
              final pickedDate = await XUtils().selectDate(date);
              if (pickedDate != null) {
                onDateSelected(pickedDate);
              }
              focusNode.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      String value,
      List<String> options,
      Function(String)? onChanged,
      [bool enabled = true]
    ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option.capitalizeFirst!),
              );
            }).toList(),
            onChanged: !enabled ? null : (newValue) => onChanged!(newValue!),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
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
            Text('Associated Clients', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            ElevatedButton.icon(
              onPressed: controller.navigateToAddContact,
              icon: Icon(Icons.add, size: 16),
              label: Text('Add Client'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bg[0],
                foregroundColor: AppColors.foreground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(() => controller.selectedClients.isEmpty
            ? _buildEmptyClientsState()
            : _buildClientsList()),
      ],
    );
  }

  Widget _buildEmptyClientsState() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 40, color: Color(0xFFCBD5E0)),
          SizedBox(height: 8),
          Text('No clients added', style: GoogleFonts.poppins(color: Color(0xFF718096))),
          SizedBox(height: 8),
          Text(
            'Clients will be associated with this case',
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFFA0AEC0)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: controller.navigateToAddContact,
            child: Text('Add First Client'),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return Column(
      children: controller.selectedClients.map((client) => _buildClientCard(client)).toList(),
    );
  }

  Widget _buildClientCard(ContactModel client) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF1A365D).withOpacity(0.1),
          child: Icon(Icons.person, color: Color(0xFF1A365D)),
        ),
        title: Text(client.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${client.type.capitalizeFirst}'),
            if (client.contactNumber != null)
              Text(client.contactNumber!, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () => controller.removeClient(client),
        ),
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
            SizedBox(width: 8),
          ],
        ),
        SizedBox(height: 12),
        Obx(() => linkCaseController.linkedCases.isEmpty
            ? _buildEmptyState('No linked cases', Icons.link_off)
            : SizedBox(
              width: double.infinity,
              child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: linkCaseController.linkedCases
                .map((kase) => _buildLinkedCaseChip(kase))
                .toList(),
              ),
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
    return Column(
      children: [
        Divider(color: Color(0xFFE2E8F0)),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.saveCase,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bg[0],
              foregroundColor: AppColors.foreground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: Obx(() => controller.isLoading.value
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save, size: 20),
                SizedBox(width: 8),
                Text('Save Case', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            )),
          ),
        ),
      ],
    );
  }
}