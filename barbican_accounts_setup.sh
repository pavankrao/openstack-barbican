#!/usr/bin/env bash
#Shell script to automate accounts creation for Openstack Barbican functional testing on RedHat OpenStack Platform Version 14.

source ~/overcloudrc
SERVICE_PROJECT_NAME=service
OS_AUTH_URL=http://10.0.0.111:5000//v3
SERVICE_PASSWORD=$(awk -FOS_PASSWORD= '{print $2}' /home/stack/overcloudrc) 


function create_barbican_accounts {
    #
    # Setup Default Admin User
    #
    SERVICE_PROJECT=$(openstack project show service -f value -c id)
    ADMIN_ROLE=$(openstack role show admin -f value -c id)
    BARBICAN_USER=$(openstack user create --password "$SERVICE_PASSWORD" --project $SERVICE_PROJECT --enable barbican -f value -c id)
    openstack role add --project $SERVICE_PROJECT --user $BARBICAN_USER $ADMIN_ROLE
    
    #
    # Setup Default service-admin User
    #
    SERVICE_ADMIN=$(openstack user create --password "$SERVICE_PASSWORD" --project "$SERVICE_PROJECT" --enable "service-admin" -f value -c id)
    SERVICE_ADMIN_ROLE=$(openstack role create "key-manager:service-admin" -f value -c id)
    openstack role add --project "$SERVICE_PROJECT" --user "$SERVICE_ADMIN" "$SERVICE_ADMIN_ROLE"
   
    #
    # Setup RBAC User Projects and Roles
    #
    PASSWORD="barbican"
    PROJECT_A_ID=$(openstack project create --enable "project_a" -f value -c id)
    PROJECT_B_ID=$(openstack project create --enable "project_b" -f value -c id)
    ROLE_ADMIN_ID=$ADMIN_ROLE
    ROLE_CREATOR_ID=$(openstack role show "creator" -f value -c id)
    ROLE_OBSERVER_ID=$(openstack role create "observer" -f value -c id)
    ROLE_AUDIT_ID=$(openstack role create "audit" -f value -c id)
    
    #
    # Setup RBAC Admin of Project A
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_A_ID" --enable "project_a_admin" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_A_ID" "$ROLE_ADMIN_ID"
    
    #
    # Setup RBAC Creator of Project A
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_A_ID" --enable "project_a_creator" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_A_ID" "$ROLE_CREATOR_ID"
    
    # Adding second creator user in project_a
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_A_ID" --enable "project_a_creator_2" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_A_ID" "$ROLE_CREATOR_ID"
    

    #
    # Setup RBAC Observer of Project A
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_A_ID" --enable "project_a_observer" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_A_ID" "$ROLE_OBSERVER_ID"
   
    #
    # Setup RBAC Auditor of Project A
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_A_ID" --enable "project_a_auditor" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_A_ID" "$ROLE_AUDIT_ID"
   

    #
    # Setup RBAC Admin of Project B
    # 
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_B_ID" --enable "project_b_admin" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_B_ID" "$ROLE_ADMIN_ID"
    
    #
    # Setup RBAC Creator of Project B
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --enable "project_b_creator" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_B_ID" "$ROLE_CREATOR_ID"
    
    #
    # Setup RBAC Observer of Project B
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_B_ID" --enable "project_b_observer" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_B_ID" "$ROLE_OBSERVER_ID"
    
    #
    # Setup RBAC auditor of Project B
    #
    USER_ID=$(openstack user create --password "$PASSWORD" --project "$PROJECT_B_ID" --enable "project_b_auditor" -f value -c id)
    openstack role add --user "$USER_ID" --project "$PROJECT_B_ID" "$ROLE_AUDIT_ID"
}


create_barbican_accounts
