package metadata

components: sources: internal_logs: {
	title:       "Internal Logs"
	description: "The internal logs source exposes all log and trace messages emitted by the running Vector instance."

	classes: {
		commonly_used: true
		delivery:      "best_effort"
		deployment_roles: ["aggregator", "daemon", "sidecar"]
		development:   "beta"
		egress_method: "stream"
		stateful:      false
	}

	features: {
		collect: {
			checkpoint: enabled: false
			from: service: {
				name:     "Vector instance"
				thing:    "a \(name)"
				url:      urls.vector_docs
				versions: ">= 0.12.0"
			}
		}
		multiline: enabled: false
	}

	support: {
		targets: {
			"aarch64-unknown-linux-gnu":      true
			"aarch64-unknown-linux-musl":     true
			"armv7-unknown-linux-gnueabihf":  true
			"armv7-unknown-linux-musleabihf": true
			"x86_64-apple-darwin":            true
			"x86_64-pc-windows-msv":          true
			"x86_64-unknown-linux-gnu":       true
			"x86_64-unknown-linux-musl":      true
		}
		notices: []
		requirements: []
		warnings: []
	}

	installation: {
		platform_name: null
	}

	configuration: {
	}

	output: logs: line: {
		description: "An individual log or trace message."
		fields: {
			message: {
				description: "The textual message for this log or trace."
				required:    true
				type: string: {
					examples: ["Vector has started."]
					syntax: "literal"
				}
			}
			timestamp: fields._current_timestamp & {
				description: "The exact time the log or trace was generated."
			}
			"*": {
				description: "Each field from the original message is copied into the event."
				required:    true
				type: "*": {}
			}
			metadata: {
				description: "Metadata from the source log or trace event."
				required:    true
				type: object: {
					examples: []
					options: {
						kind: {
							description: "What kind of call site caused this log or trace."
							required:    true
							type: string: {
								enum: {
									event: "The call site is an event."
									span:  "The call site is a span."
								}
								syntax: "literal"
							}
						}
						level: {
							description: "The level of verbosity of the described span or event."
							required:    true
							type: string: {
								enum: {
									TRACE: "Designates very low priority, often extremely verbose, information."
									DEBUG: "Designates lower priority information."
									INFO:  "Designates useful information."
									WARN:  "Designates hazardous situations."
									ERROR: "Designates very serious errors."
								}
								syntax: "literal"
							}
						}
						module_path: {
							description: "The path to the internal module where the span occurred"
							required:    true
							type: string: {
								examples: ["vector::internal_events::heartbeat"]
								syntax: "literal"
							}
						}
						target: {
							description: "Describes the part of the system where the span or event that this metadata describes occurred."
							required:    true
							type: string: {
								examples: ["vector"]
								syntax: "literal"
							}
						}
					}
				}
			}
		}
	}

	how_it_works: {
		limited_logs: {
			title: "Logs are limited by startup options"
			body: """
				At startup, the selection of log messages generated by Vector is determined by a
				combination of the `LOG` environment variable and the `--quiet` and `--verbose`
				command-line options. The `internal_logs` source only receives logs that are generated by these options.
				"""
		}
	}
}
