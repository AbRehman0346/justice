import '../models/case-model.dart';
import '../models/contact-model.dart';
import '../models/date-model.dart';
class CasesData{
  static late List<CaseModel> cases;

  void init(){
    HearingStatus status = HearingStatus();
    CaseStatus caseStatus = CaseStatus();
    cases =   [
      CaseModel(
        id: '1',
        title: 'Smith vs Johnson Property Dispute',
        court: 'Supreme Court',
        city: 'New York',
        caseNumber: 'SC-2024-001',
        date: null,
        clientIds: [
          contact("John Smith"),
        ],
        status: caseStatus.active,
        priority: 'high',
        proceedingsDetails: '',
        caseStage: 'Evidance',
        createdAt: DateTime.now(),
      ),
      CaseModel(
        id: '2',
        title: 'Corporate Merger Approval',
        court: 'High Court',
        city: 'Los Angeles',
        date: null,
        caseNumber: 'HC-2024-045',
        clientIds: [
          contact("Tech Corp Inc.")
        ],
        status: caseStatus.active,
        priority: 'medium',
        proceedingsDetails: "",
        caseStage: 'Evidance',
        createdAt: DateTime.now(),
      ),
      CaseModel(
        id: '3',
        title: 'Intellectual Property Rights',
        court: 'District Court',
        city: 'Chicago',
        date: null,
        caseNumber: 'DC-2024-123',
        clientIds: [
          contact("Innovate Labs")
        ],
        status: caseStatus.active,
        priority: 'high',
        proceedingsDetails: '',
        caseStage: 'Evidance',
        createdAt: DateTime.now(),
      ),
      CaseModel(
        id: '4',
        title: 'Employment Contract Dispute',
        court: 'Labor Court',
        city: 'Houston',
        date: null,
        caseNumber: 'LC-2024-078',
        clientIds: [
          contact('Maria Rodriguez')
        ],
        status: caseStatus.disposeOff,
        priority: 'low',
        proceedingsDetails: '',
        caseStage: '',
        createdAt: DateTime.now(),
      ),
      CaseModel(
        id: '5',
        title: 'Criminal Defense - Burglary',
        court: 'Criminal Court',
        city: 'Miami',
        date: null,
        caseNumber: 'CC-2024-156',
        clientIds: [
          contact('Robert Brown')
        ],
        status: caseStatus.active,
        priority: 'medium',
        proceedingsDetails: '',
        caseStage: '',
        createdAt: DateTime.now(),
      ),
      CaseModel(
        id: '6',
        title: 'Smith vs Johnson Property Dispute',
        court: 'Supreme Court',
        city: 'New York',
        status: caseStatus.disposeOff,
        priority: 'high',
        proceedingsDetails: 'This case involves a property dispute between two parties regarding the ownership of a commercial building in downtown Manhattan. The plaintiff claims ancestral rights while the defendant has purchase documents.',
        caseStage: 'First Hearing',
        createdAt: DateTime.now(),
        caseNumber: 'SC-2024-001',
        caseType: 'Civil',
        date: CaseHearingsDateModel(
          prevDate: [PrevHearingDateModel(date: DateTime(2024, 1, 15), dateStatus: status.attended)],
          upcomingDate: DateTime(2024, 2, 20),
          dateStatus: status.attended,
          dateNotes: 'Both parties presented preliminary arguments. Next hearing scheduled for evidence submission.',
        ),
        clientIds: [
          ContactModel(
            id: '1',
            name: 'John Smith',
            contactNumber: '+1-555-0101',
            email: 'john.smith@email.com',
            type: 'client',
            createdAt: DateTime.now(),
          ),
          ContactModel(
            id: '2',
            name: 'Smith Properties Inc.',
            contactNumber: '+1-555-0102',
            email: 'legal@smithproperties.com',
            type: 'client',
            createdAt: DateTime.now(),
          ),
        ],
        linkedCaseId: ['CASE-2023-045', 'CASE-2023-078'],
      ),  // with full details
      CaseModel(
        id: '7',
        title: 'Smith vs Johnson Property Dispute',
        proceedingsDetails: 'Hearing for preliminary arguments',
        date: CaseHearingsDateModel(
          prevDate: [PrevHearingDateModel(date: DateTime(2025, 9, 20), dateStatus: status.attended)],
          upcomingDate: DateTime(2025, 9, 27),
          dateStatus: status.upcoming,
        ),
        caseStage: 'First Hearing',
        caseType: 'Civil',
        court: 'Supreme Court',
        clientIds: [
          contact("John Smith")
        ],
        createdAt: DateTime.now(),
        priority: 'high',
        city: '',
        status: caseStatus.active,
      ),
      CaseModel(
        id: '8',
        title: 'Corporate Merger Approval',
        proceedingsDetails: 'Final hearing for merger approval',
        date: CaseHearingsDateModel(
          prevDate: [PrevHearingDateModel(date: DateTime(2025, 9, 10), dateStatus: status.attended)],
          upcomingDate: DateTime(2025, 9, 28),
          dateStatus: status.upcoming,
        ),
        caseStage: 'Arguments',
        caseType: 'Corporate',
        court: 'High Court',
        clientIds: [
          contact("Sarfaraz")
        ],
        createdAt: DateTime.now(),
        priority: 'medium',
        city: '',
        status: caseStatus.active,
      ),
      CaseModel(
        id: '9',
        title: 'Intellectual Property Rights',
        proceedingsDetails: 'Evidence submission',
        date: CaseHearingsDateModel(
          prevDate: [PrevHearingDateModel(date: DateTime(2024, 1, 5), dateStatus: status.attended)],
          upcomingDate: DateTime(2024, 2, 25),
          dateStatus: status.upcoming,
        ),
        caseStage: 'Evidence',
        caseType: 'Intellectual Property',
        court: 'District Court',
        clientIds: [contact("Arslan")],
        createdAt: DateTime.now(),
        priority: 'high',
        city: '',
        status: caseStatus.active,

      ),
      CaseModel(
        id: '10',
        title: 'Employment Contract Dispute',
        proceedingsDetails: 'Mediation session',
        date: CaseHearingsDateModel(
          prevDate: [PrevHearingDateModel(date: DateTime(2025, 1, 20), dateStatus: status.attended)],
          upcomingDate: DateTime(2025, 2, 18),
          dateStatus: status.adjourned,
        ),
        caseStage: 'Mediation',
        caseType: 'Labor',
        court: 'Labor Court',
        clientIds: [contact("Akbar")],
        createdAt: DateTime.now(),
        priority: 'low',
        city: '',
        status: caseStatus.active,
      ),
    ];
  }

  static ContactModel contact(String name){
    return ContactModel(
      id: "id",
      contactNumber: null,
      type: ContactType().client,
      name: name,
      createdAt: DateTime.now(),
    );
  }
}