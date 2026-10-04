{{- define "cloud-platform-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cloud-platform-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "cloud-platform-app.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cloud-platform-app.labels" -}}
app.kubernetes.io/name: {{ include "cloud-platform-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}
