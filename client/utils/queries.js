import { gql } from '@apollo/client';

export const SERVICE_COUNT = gql`
	query serviceCount {
		serviceCount
	}
`;
export const PERSISTED_QUERIES_COUNT = gql`
	query persistedQueriesCount {
		persistedQueriesCount
	}
`;

export const PERSISTED_QUERIES = gql`
	query persistedQueries {
		persistedQueries {
			key
			query
			addedTime
		}
	}
`;

export const SERVICES_LIST = gql`
	query getServices {
		services {
			id
			name
		}
	}
`;

export const SERVICE_SCHEMAS = gql`
	query getServiceVersions($id: Int!, $filter: String) {
		service(id: $id) {
			id

			schemas(limit: 100, filter: $filter) {
				id
				isActive
				addedTime
				typeDefs
				isDev

				characters
				previousSchema {
					characters
				}
			}
		}
	}
`;

export const SCHEMA_DETAILS = gql`
	query getSchema($schemaId: Int!) {
		schema(id: $schemaId) {
			id
			typeDefs
			isActive
			addedTime

			service {
				url
			}

			containerCount

			containers {
				version
				addedTime
				commitLink
			}

			previousSchema {
				typeDefs
			}
		}
	}
`;

export const SCHEMA_SDL = gql`
	query getSchemaSDL($schemaId: Int!) {
		schema(id: $schemaId) {
			fieldsUsage {
				entity
				property
				clientVersionId
				hitsSum
			}
		}
	}
`;
export const SCHEMA_USAGE_SDL = gql`
	query getSchemaUsageSDL($entity: String!, $property: String!) {
		schemaPropertyHitsByClient(entity: $entity, property: $property) {
			hits
			day
			clientName
		}
	}
`;
