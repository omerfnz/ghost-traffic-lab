enum ServiceStatus {
  idle('Idle', 'System disarmed'),
  armed('Armed', 'Waiting for trigger'),
  running('Running', 'Executing payload'),
  error('Error', 'Something went wrong');

  const ServiceStatus(this.label, this.description);

  final String label;
  final String description;
}
