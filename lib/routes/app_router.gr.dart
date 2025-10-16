// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddDiagnosisRoute.name: (routeData) {
      final args = routeData.argsAs<AddDiagnosisRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddDiagnosisPage(
          key: args.key,
          patientId: args.patientId,
          complaintId: args.complaintId,
          visitIndex: args.visitIndex,
        ),
      );
    },
    AddObservationRoute.name: (routeData) {
      final args = routeData.argsAs<AddObservationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddObservationPage(
          key: args.key,
          patientId: args.patientId,
          complaintId: args.complaintId,
          visitIndex: args.visitIndex,
        ),
      );
    },
    AdminDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AdminDashboardPage(),
      );
    },
    DiagnosisRoute.name: (routeData) {
      final args = routeData.argsAs<DiagnosisRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DiagnosisPage(
          key: args.key,
          patientId: args.patientId,
          complaintId: args.complaintId,
        ),
      );
    },
    DoctorDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DoctorDashboardPage(),
      );
    },
    EditPatientAdminRoute.name: (routeData) {
      final args = routeData.argsAs<EditPatientAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditPatientAdminPage(
          key: args.key,
          patientId: args.patientId,
        ),
      );
    },
    EditPatientRoute.name: (routeData) {
      final args = routeData.argsAs<EditPatientRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditPatientPage(
          key: args.key,
          patientId: args.patientId,
        ),
      );
    },
    ImportPatientsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ImportPatientsPage(),
      );
    },
    ImportedPatientsVisitRoute.name: (routeData) {
      final args = routeData.argsAs<ImportedPatientsVisitRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ImportedPatientsVisitPage(
          key: args.key,
          patientId: args.patientId,
          name: args.name,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    ObservationRoute.name: (routeData) {
      final args = routeData.argsAs<ObservationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ObservationPage(
          key: args.key,
          name: args.name,
          id: args.id,
          visitingIndex: args.visitingIndex,
        ),
      );
    },
    PatientAdminInvisitsRoute.name: (routeData) {
      final args = routeData.argsAs<PatientAdminInvisitsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PatientAdminInvisitsPage(
          key: args.key,
          patientId: args.patientId,
          name: args.name,
        ),
      );
    },
    PatientAdminOutvisitsRoute.name: (routeData) {
      final args = routeData.argsAs<PatientAdminOutvisitsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PatientAdminOutvisitsPage(
          key: args.key,
          patientId: args.patientId,
        ),
      );
    },
    PatientInvisitsRoute.name: (routeData) {
      final args = routeData.argsAs<PatientInvisitsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PatientInvisitsPage(
          key: args.key,
          patientId: args.patientId,
          name: args.name,
        ),
      );
    },
    PatientOutvisitsRoute.name: (routeData) {
      final args = routeData.argsAs<PatientOutvisitsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PatientOutvisitsPage(
          key: args.key,
          patientId: args.patientId,
        ),
      );
    },
    RegisterNewPatientRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterNewPatientPage(),
      );
    },
    RegisterPatientRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPatientPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    StaffDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StaffDashboardPage(),
      );
    },
    SupportingstaffPatientInvisitsRoute.name: (routeData) {
      final args = routeData.argsAs<SupportingstaffPatientInvisitsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SupportingstaffPatientInvisitsPage(
          key: args.key,
          patientId: args.patientId,
          name: args.name,
        ),
      );
    },
    ViewDiagnosisRoute.name: (routeData) {
      final args = routeData.argsAs<ViewDiagnosisRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewDiagnosisPage(
          key: args.key,
          name: args.name,
          id: args.id,
          visitingIndex: args.visitingIndex,
          dischargeddate: args.dischargeddate,
        ),
      );
    },
  };
}

/// generated route for
/// [AddDiagnosisPage]
class AddDiagnosisRoute extends PageRouteInfo<AddDiagnosisRouteArgs> {
  AddDiagnosisRoute({
    Key? key,
    required String patientId,
    required String complaintId,
    required int visitIndex,
    List<PageRouteInfo>? children,
  }) : super(
          AddDiagnosisRoute.name,
          args: AddDiagnosisRouteArgs(
            key: key,
            patientId: patientId,
            complaintId: complaintId,
            visitIndex: visitIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'AddDiagnosisRoute';

  static const PageInfo<AddDiagnosisRouteArgs> page =
      PageInfo<AddDiagnosisRouteArgs>(name);
}

class AddDiagnosisRouteArgs {
  const AddDiagnosisRouteArgs({
    this.key,
    required this.patientId,
    required this.complaintId,
    required this.visitIndex,
  });

  final Key? key;

  final String patientId;

  final String complaintId;

  final int visitIndex;

  @override
  String toString() {
    return 'AddDiagnosisRouteArgs{key: $key, patientId: $patientId, complaintId: $complaintId, visitIndex: $visitIndex}';
  }
}

/// generated route for
/// [AddObservationPage]
class AddObservationRoute extends PageRouteInfo<AddObservationRouteArgs> {
  AddObservationRoute({
    Key? key,
    required String patientId,
    required String complaintId,
    required int visitIndex,
    List<PageRouteInfo>? children,
  }) : super(
          AddObservationRoute.name,
          args: AddObservationRouteArgs(
            key: key,
            patientId: patientId,
            complaintId: complaintId,
            visitIndex: visitIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'AddObservationRoute';

  static const PageInfo<AddObservationRouteArgs> page =
      PageInfo<AddObservationRouteArgs>(name);
}

class AddObservationRouteArgs {
  const AddObservationRouteArgs({
    this.key,
    required this.patientId,
    required this.complaintId,
    required this.visitIndex,
  });

  final Key? key;

  final String patientId;

  final String complaintId;

  final int visitIndex;

  @override
  String toString() {
    return 'AddObservationRouteArgs{key: $key, patientId: $patientId, complaintId: $complaintId, visitIndex: $visitIndex}';
  }
}

/// generated route for
/// [AdminDashboardPage]
class AdminDashboardRoute extends PageRouteInfo<void> {
  const AdminDashboardRoute({List<PageRouteInfo>? children})
      : super(
          AdminDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DiagnosisPage]
class DiagnosisRoute extends PageRouteInfo<DiagnosisRouteArgs> {
  DiagnosisRoute({
    Key? key,
    required String patientId,
    required String complaintId,
    List<PageRouteInfo>? children,
  }) : super(
          DiagnosisRoute.name,
          args: DiagnosisRouteArgs(
            key: key,
            patientId: patientId,
            complaintId: complaintId,
          ),
          initialChildren: children,
        );

  static const String name = 'DiagnosisRoute';

  static const PageInfo<DiagnosisRouteArgs> page =
      PageInfo<DiagnosisRouteArgs>(name);
}

class DiagnosisRouteArgs {
  const DiagnosisRouteArgs({
    this.key,
    required this.patientId,
    required this.complaintId,
  });

  final Key? key;

  final String patientId;

  final String complaintId;

  @override
  String toString() {
    return 'DiagnosisRouteArgs{key: $key, patientId: $patientId, complaintId: $complaintId}';
  }
}

/// generated route for
/// [DoctorDashboardPage]
class DoctorDashboardRoute extends PageRouteInfo<void> {
  const DoctorDashboardRoute({List<PageRouteInfo>? children})
      : super(
          DoctorDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DoctorDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditPatientAdminPage]
class EditPatientAdminRoute extends PageRouteInfo<EditPatientAdminRouteArgs> {
  EditPatientAdminRoute({
    Key? key,
    required String patientId,
    List<PageRouteInfo>? children,
  }) : super(
          EditPatientAdminRoute.name,
          args: EditPatientAdminRouteArgs(
            key: key,
            patientId: patientId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditPatientAdminRoute';

  static const PageInfo<EditPatientAdminRouteArgs> page =
      PageInfo<EditPatientAdminRouteArgs>(name);
}

class EditPatientAdminRouteArgs {
  const EditPatientAdminRouteArgs({
    this.key,
    required this.patientId,
  });

  final Key? key;

  final String patientId;

  @override
  String toString() {
    return 'EditPatientAdminRouteArgs{key: $key, patientId: $patientId}';
  }
}

/// generated route for
/// [EditPatientPage]
class EditPatientRoute extends PageRouteInfo<EditPatientRouteArgs> {
  EditPatientRoute({
    Key? key,
    required String patientId,
    List<PageRouteInfo>? children,
  }) : super(
          EditPatientRoute.name,
          args: EditPatientRouteArgs(
            key: key,
            patientId: patientId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditPatientRoute';

  static const PageInfo<EditPatientRouteArgs> page =
      PageInfo<EditPatientRouteArgs>(name);
}

class EditPatientRouteArgs {
  const EditPatientRouteArgs({
    this.key,
    required this.patientId,
  });

  final Key? key;

  final String patientId;

  @override
  String toString() {
    return 'EditPatientRouteArgs{key: $key, patientId: $patientId}';
  }
}

/// generated route for
/// [ImportPatientsPage]
class ImportPatientsRoute extends PageRouteInfo<void> {
  const ImportPatientsRoute({List<PageRouteInfo>? children})
      : super(
          ImportPatientsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImportPatientsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ImportedPatientsVisitPage]
class ImportedPatientsVisitRoute
    extends PageRouteInfo<ImportedPatientsVisitRouteArgs> {
  ImportedPatientsVisitRoute({
    Key? key,
    required String patientId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          ImportedPatientsVisitRoute.name,
          args: ImportedPatientsVisitRouteArgs(
            key: key,
            patientId: patientId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'ImportedPatientsVisitRoute';

  static const PageInfo<ImportedPatientsVisitRouteArgs> page =
      PageInfo<ImportedPatientsVisitRouteArgs>(name);
}

class ImportedPatientsVisitRouteArgs {
  const ImportedPatientsVisitRouteArgs({
    this.key,
    required this.patientId,
    required this.name,
  });

  final Key? key;

  final String patientId;

  final String name;

  @override
  String toString() {
    return 'ImportedPatientsVisitRouteArgs{key: $key, patientId: $patientId, name: $name}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ObservationPage]
class ObservationRoute extends PageRouteInfo<ObservationRouteArgs> {
  ObservationRoute({
    Key? key,
    required String name,
    required String id,
    required int visitingIndex,
    List<PageRouteInfo>? children,
  }) : super(
          ObservationRoute.name,
          args: ObservationRouteArgs(
            key: key,
            name: name,
            id: id,
            visitingIndex: visitingIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'ObservationRoute';

  static const PageInfo<ObservationRouteArgs> page =
      PageInfo<ObservationRouteArgs>(name);
}

class ObservationRouteArgs {
  const ObservationRouteArgs({
    this.key,
    required this.name,
    required this.id,
    required this.visitingIndex,
  });

  final Key? key;

  final String name;

  final String id;

  final int visitingIndex;

  @override
  String toString() {
    return 'ObservationRouteArgs{key: $key, name: $name, id: $id, visitingIndex: $visitingIndex}';
  }
}

/// generated route for
/// [PatientAdminInvisitsPage]
class PatientAdminInvisitsRoute
    extends PageRouteInfo<PatientAdminInvisitsRouteArgs> {
  PatientAdminInvisitsRoute({
    Key? key,
    required String patientId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          PatientAdminInvisitsRoute.name,
          args: PatientAdminInvisitsRouteArgs(
            key: key,
            patientId: patientId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'PatientAdminInvisitsRoute';

  static const PageInfo<PatientAdminInvisitsRouteArgs> page =
      PageInfo<PatientAdminInvisitsRouteArgs>(name);
}

class PatientAdminInvisitsRouteArgs {
  const PatientAdminInvisitsRouteArgs({
    this.key,
    required this.patientId,
    required this.name,
  });

  final Key? key;

  final String patientId;

  final String name;

  @override
  String toString() {
    return 'PatientAdminInvisitsRouteArgs{key: $key, patientId: $patientId, name: $name}';
  }
}

/// generated route for
/// [PatientAdminOutvisitsPage]
class PatientAdminOutvisitsRoute
    extends PageRouteInfo<PatientAdminOutvisitsRouteArgs> {
  PatientAdminOutvisitsRoute({
    Key? key,
    required String patientId,
    List<PageRouteInfo>? children,
  }) : super(
          PatientAdminOutvisitsRoute.name,
          args: PatientAdminOutvisitsRouteArgs(
            key: key,
            patientId: patientId,
          ),
          initialChildren: children,
        );

  static const String name = 'PatientAdminOutvisitsRoute';

  static const PageInfo<PatientAdminOutvisitsRouteArgs> page =
      PageInfo<PatientAdminOutvisitsRouteArgs>(name);
}

class PatientAdminOutvisitsRouteArgs {
  const PatientAdminOutvisitsRouteArgs({
    this.key,
    required this.patientId,
  });

  final Key? key;

  final String patientId;

  @override
  String toString() {
    return 'PatientAdminOutvisitsRouteArgs{key: $key, patientId: $patientId}';
  }
}

/// generated route for
/// [PatientInvisitsPage]
class PatientInvisitsRoute extends PageRouteInfo<PatientInvisitsRouteArgs> {
  PatientInvisitsRoute({
    Key? key,
    required String patientId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          PatientInvisitsRoute.name,
          args: PatientInvisitsRouteArgs(
            key: key,
            patientId: patientId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'PatientInvisitsRoute';

  static const PageInfo<PatientInvisitsRouteArgs> page =
      PageInfo<PatientInvisitsRouteArgs>(name);
}

class PatientInvisitsRouteArgs {
  const PatientInvisitsRouteArgs({
    this.key,
    required this.patientId,
    required this.name,
  });

  final Key? key;

  final String patientId;

  final String name;

  @override
  String toString() {
    return 'PatientInvisitsRouteArgs{key: $key, patientId: $patientId, name: $name}';
  }
}

/// generated route for
/// [PatientOutvisitsPage]
class PatientOutvisitsRoute extends PageRouteInfo<PatientOutvisitsRouteArgs> {
  PatientOutvisitsRoute({
    Key? key,
    required String patientId,
    List<PageRouteInfo>? children,
  }) : super(
          PatientOutvisitsRoute.name,
          args: PatientOutvisitsRouteArgs(
            key: key,
            patientId: patientId,
          ),
          initialChildren: children,
        );

  static const String name = 'PatientOutvisitsRoute';

  static const PageInfo<PatientOutvisitsRouteArgs> page =
      PageInfo<PatientOutvisitsRouteArgs>(name);
}

class PatientOutvisitsRouteArgs {
  const PatientOutvisitsRouteArgs({
    this.key,
    required this.patientId,
  });

  final Key? key;

  final String patientId;

  @override
  String toString() {
    return 'PatientOutvisitsRouteArgs{key: $key, patientId: $patientId}';
  }
}

/// generated route for
/// [RegisterNewPatientPage]
class RegisterNewPatientRoute extends PageRouteInfo<void> {
  const RegisterNewPatientRoute({List<PageRouteInfo>? children})
      : super(
          RegisterNewPatientRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterNewPatientRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPatientPage]
class RegisterPatientRoute extends PageRouteInfo<void> {
  const RegisterPatientRoute({List<PageRouteInfo>? children})
      : super(
          RegisterPatientRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterPatientRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StaffDashboardPage]
class StaffDashboardRoute extends PageRouteInfo<void> {
  const StaffDashboardRoute({List<PageRouteInfo>? children})
      : super(
          StaffDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'StaffDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SupportingstaffPatientInvisitsPage]
class SupportingstaffPatientInvisitsRoute
    extends PageRouteInfo<SupportingstaffPatientInvisitsRouteArgs> {
  SupportingstaffPatientInvisitsRoute({
    Key? key,
    required String patientId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          SupportingstaffPatientInvisitsRoute.name,
          args: SupportingstaffPatientInvisitsRouteArgs(
            key: key,
            patientId: patientId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'SupportingstaffPatientInvisitsRoute';

  static const PageInfo<SupportingstaffPatientInvisitsRouteArgs> page =
      PageInfo<SupportingstaffPatientInvisitsRouteArgs>(name);
}

class SupportingstaffPatientInvisitsRouteArgs {
  const SupportingstaffPatientInvisitsRouteArgs({
    this.key,
    required this.patientId,
    required this.name,
  });

  final Key? key;

  final String patientId;

  final String name;

  @override
  String toString() {
    return 'SupportingstaffPatientInvisitsRouteArgs{key: $key, patientId: $patientId, name: $name}';
  }
}

/// generated route for
/// [ViewDiagnosisPage]
class ViewDiagnosisRoute extends PageRouteInfo<ViewDiagnosisRouteArgs> {
  ViewDiagnosisRoute({
    Key? key,
    required String name,
    required String id,
    required int visitingIndex,
    required String dischargeddate,
    List<PageRouteInfo>? children,
  }) : super(
          ViewDiagnosisRoute.name,
          args: ViewDiagnosisRouteArgs(
            key: key,
            name: name,
            id: id,
            visitingIndex: visitingIndex,
            dischargeddate: dischargeddate,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewDiagnosisRoute';

  static const PageInfo<ViewDiagnosisRouteArgs> page =
      PageInfo<ViewDiagnosisRouteArgs>(name);
}

class ViewDiagnosisRouteArgs {
  const ViewDiagnosisRouteArgs({
    this.key,
    required this.name,
    required this.id,
    required this.visitingIndex,
    required this.dischargeddate,
  });

  final Key? key;

  final String name;

  final String id;

  final int visitingIndex;

  final String dischargeddate;

  @override
  String toString() {
    return 'ViewDiagnosisRouteArgs{key: $key, name: $name, id: $id, visitingIndex: $visitingIndex, dischargeddate: $dischargeddate}';
  }
}
