# :pick: MineCloud Ops - Projet Final

Ce projet automatise entièrement le déploiement d'un serveur Minecraft sur Google Cloud Platform (GCP). Il respecte les principes **DevOps** modernes : *Infrastructure as Code* et *Immutable Infrastructure*.

## :construction_site: Architecture

Le projet repose sur la stack technique suivante :

* **Packer** : Création d'une "Golden Image" (Ubuntu + Docker + Outils système).
* **Terraform** : Provisionnement de l'infrastructure (VM Compute Engine, Pare-feu, Réseau).
* **Ansible** : Configuration finale et déploiement de l'application.
* **Docker & Docker Compose** : Conteneurisation du serveur Minecraft et de l'interface Web.
* **Python (Flask)** : Page de statut Web (Bonus) pour surveiller l'état du serveur en temps réel.

---

## :clipboard: Prérequis

* Un compte **Google Cloud Platform (GCP)** avec un projet actif.
* **Google Cloud Shell** (recommandé) ou un terminal local avec les outils suivants installés :
    * `gcloud` CLI
    * `packer`
    * `terraform`
    * `ansible`

---

## :rocket: Guide de Déploiement (De A à Z)

Suivez ces étapes pour déployer le serveur depuis zéro.

### Étape 1 : Création de la Golden Image (Packer)

Nous allons créer une image disque contenant déjà toutes les dépendances (Docker, Git, htop, etc.).

1.  Placez-vous dans le dossier Packer :
    ```bash
    cd packer
    ```
2.  Initialisez les plugins et lancez la construction :
    ```bash
    packer init ubuntu-docker.pkr.hcl
    packer build ubuntu-docker.pkr.hcl
    ```
    *(Si vous avez une erreur d'authentification, lancez `gcloud auth application-default login` avant).*

3.  **Important :** À la fin, copiez l'ID de l'image créée (ex: `minecloud-base-v1-1770109966`).

### Étape 2 : Déploiement de l'Application (Ansible)

Nous allons configurer le serveur et lancer Minecraft ainsi que la page Web de monitoring.

1.  Revenez à la racine du projet :
    ```bash
    cd ..
    ```
2.  Créez le fichier d'inventaire avec l'IP de votre serveur :
    ```bash
    echo "[minecloud]" > inventory.ini
    echo "34.78.XX.XX" >> inventory.ini  # Remplacer par votre vraie IP
    ```
3.  Lancez le playbook de déploiement :
    ```bash
    ansible-playbook -i inventory.ini ansible/deploy.yml
    ```

---

## :video_game: Accès aux Services

Une fois le déploiement terminé, vous pouvez accéder à :

* **Serveur Minecraft** :
    * Adresse : `34.22.XX.XX`
    * Port : `25565`

---

## :open_file_folder: Structure du Projet

```text
minecloud-ops/
├── ansible/
│   ├── roles/common/     # Installation de Docker et outils de base
│   └── deploy.yml        # Playbook de déploiement de l'app
├── app/
│   ├── web/              # Code Python/Flask (Bonus)
│   └── docker-compose.yml
├── packer/
│   └── ubuntu-docker.pkr.hcl  # Configuration de l'image
├── terraform/
│   ├── main.tf           # Définition VM + Firewall
│   └── variables.tf
└── README.md
