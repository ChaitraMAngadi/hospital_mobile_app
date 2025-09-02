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
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
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
    ViewDiagnosisRoute.name: (routeData) {
      final args = routeData.argsAs<ViewDiagnosisRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewDiagnosisPage(
          key: args.key,
          name: args.name,
          id: args.id,
          visitingIndex: args.visitingIndex,
        ),
      );
    },
  };
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
/// [ViewDiagnosisPage]
class ViewDiagnosisRoute extends PageRouteInfo<ViewDiagnosisRouteArgs> {
  ViewDiagnosisRoute({
    Key? key,
    required String name,
    required String id,
    required int visitingIndex,
    List<PageRouteInfo>? children,
  }) : super(
          ViewDiagnosisRoute.name,
          args: ViewDiagnosisRouteArgs(
            key: key,
            name: name,
            id: id,
            visitingIndex: visitingIndex,
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
  });

  final Key? key;

  final String name;

  final String id;

  final int visitingIndex;

  @override
  String toString() {
    return 'ViewDiagnosisRouteArgs{key: $key, name: $name, id: $id, visitingIndex: $visitingIndex}';
  }
}
